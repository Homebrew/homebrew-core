class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "5ea0f1003af1801a6a85d201b6fa7e1de46686fccb7df1d3fa3a03c4ec2be68c"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4fe04ae03f26ca0f96cd89beebb4a8b91d346a2264a9c62b647becd5aed7bb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "290f23dd8caee3c32df132477b146497927554c05f113176aa246be46aa6dc81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d68999368177b5d253464f8af9eeb4c95c3061906013d02c3b15d666dd86407b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cdc2d90fb9c50a0a0c90335ae067d2c64c694674d5b0240c137b5bc5f7801d6"
    sha256 cellar: :any,                 arm64_linux:   "38a6f8ffb0e2cefa486fdfee790cf8a3cb8b80535e8c29f1b30c3b73f54a29c2"
    sha256 cellar: :any,                 x86_64_linux:  "a9a919a586602af5da3113426530921f7a64db8e6673bfcec1ced7cadfcc4aaa"
  end

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build # upstream issue, https://github.com/ogulcancelik/herdr/issues/285

  def install
    ENV.prepend_path "PATH", formula_opt_bin("zig@0.15")

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
