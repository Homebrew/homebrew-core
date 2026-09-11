class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://github.com/herdrdev/herdr/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "1e83bff4b05834ed8281e16f1680e8f3e58375a94b2e3f2b3d021e28e293ef9a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/herdrdev/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9c8778478c3e47edc2f944374fd444fcb736ce6f5884d89e131d74eb41242f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff3b064d1591a07ad16c14c76d89fd4d6f1c21735dd2363f5a26d37f5f9d052d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fda947866b0d96e8a204902338e8c6fc2c5355e7aa04d716c681d8dda7df8a70"
    sha256 cellar: :any,                 arm64_linux:   "dc2940a96359fab617cf1c18881cd3fd8a6fd156a11f040a85ceef0fea12e0fc"
    sha256 cellar: :any,                 x86_64_linux:  "93237c69194d2332df2ed8fd38bee203e25c56ba2d76198d192c8301b114660c"
  end

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build # upstream issue, https://github.com/herdrdev/herdr/issues/285

  def install
    ENV.prepend_path "PATH", formula_opt_bin("zig@0.15")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"herdr", "completion")
  end

  service do
    run [opt_bin/"herdr", "server"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/herdr.log"
    error_log_path var/"log/herdr.log"
  end

  def caveats
    <<~EOS
      The service PATH only includes Homebrew and system directories. If a
      Herdr plugin needs a tool installed elsewhere, add a PATH override in
      ~/.homebrew/services/herdr.env and run `brew services restart herdr`.
    EOS
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
