class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://github.com/herdrdev/herdr/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "03403d3ef80dcf2b954dd5d27eb636e6c4f5279d240b48de272b7f53e4b73093"
  license "Apache-2.0"
  head "https://github.com/herdrdev/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b2967a9b054c032e5a1b4362821a431bd5ebe2c3b4a72241da7be7f1ef9fe01"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "617e3f79d08d6dba1eb0e85983471c76b7c624ef977c616b36a4953fb2033f06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b818a170527ceeffe0b4a57679a4c85f2b83a314143cede0cd4a6b62dd18158f"
    sha256 cellar: :any,                 arm64_linux:       "3bd0ed1b9352432e95cc9b0e673c74e531b28ca0412362f4a72287f39740b81e"
    sha256 cellar: :any,                 x86_64_linux:      "acc8698edacde2b840a5fe62325421fd40e033e3da1037ce72401b278bedd6f8"
  end

  depends_on "rust" => :build
  depends_on "zig" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"herdr", "completion")
  end

  service do
    run [opt_bin/"herdr", "server"]
    keep_alive true
    log_path var/"log/herdr.log"
    error_log_path var/"log/herdr.log"
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
