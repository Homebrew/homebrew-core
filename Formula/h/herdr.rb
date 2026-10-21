class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://github.com/herdrdev/herdr/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "a2486b09a8153630f6a19e72606ba1c961a6194bce13c09cba67ccce5e4252de"
  license "Apache-2.0"
  head "https://github.com/herdrdev/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8388671d573476682d75b7517fbef151d75bc92e4a5859100dd7975c165bd1c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "098f518ee5ce5438495eff09ddf67d7372a5ca60dfe995e6e4bfe5dd10391798"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1a0773148e4ad392a75123f6ac6f23031d8957c658bb5525528aab12015bee5"
    sha256 cellar: :any,                 arm64_linux:       "2ec4113acb84c6e47f77b7cefd3743b09d253d08f5ce53217d783c8306080701"
    sha256 cellar: :any,                 x86_64_linux:      "eeef311abfa814833f7a380439b9f9e489f18fe0a476866d5815c33544c2aa6f"
  end

  depends_on "rust" => :build
  depends_on "zig@0.16" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    cd "vendor/libghostty-vt" do
      system "zig", "build", "--fetch=all"
    end
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"herdr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/herdr --version")

    ENV["HOME"] = testpath.to_s
    ENV["XDG_CONFIG_HOME"] = (testpath/"config").to_s
    ENV["XDG_STATE_HOME"] = (testpath/"state").to_s
    ENV["HERDR_CONFIG_PATH"] = (testpath/"config.toml").to_s
    ENV["HERDR_SOCKET_PATH"] = (testpath/"herdr.sock").to_s

    pid = spawn bin/"herdr", "server"
    status = ""
    10.times do
      status = shell_output("#{bin}/herdr status server")
      break if status.include?("status: running")

      sleep 1
    end
    assert_match "status: running", status
    assert_match "version: #{version}", status

    output = shell_output("#{bin}/herdr workspace create --label brew-test --no-focus")
    workspace = JSON.parse(output).dig("result", "workspace")
    assert_equal "brew-test", workspace["label"]

    output = shell_output("#{bin}/herdr workspace list")
    workspaces = JSON.parse(output).dig("result", "workspaces")
    assert_includes workspaces.map { |entry| entry["workspace_id"] }, workspace["workspace_id"]
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
