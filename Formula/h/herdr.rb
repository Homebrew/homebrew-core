class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "0c7f8f96ccd66c03bfbab94f09c013149c2a2fcb84e8e61093a297f367344a09"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be6a922a396d3882e2fd947d4f0ac9126d909d00118425f4ca892ad57337aed7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dc9ad437aba0d46e63e99136bb1dc05d365b8502820f776bc3a985f5b491f24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a67519dde3f71d33a5a2c5b9bb54a78fc1d968f77c0ce316b0a4c9a58495882"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3f1157a726fea219e03c3f81e739f3be83f74932f8a3f3c74f7e5f57e8870d2"
    sha256 cellar: :any,                 arm64_linux:   "1d6135a6df348093b7f660bed0a216a71973fb9a5903c9276af1ec51ff7fb3fe"
    sha256 cellar: :any,                 x86_64_linux:  "15a8b21bacf863d81788b1fc75daee1f4d3daabd60df1094931933dbd02bfb9b"
  end

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build # upstream issue, https://github.com/ogulcancelik/herdr/issues/285

  def install
    ENV.prepend_path "PATH", Formula["zig@0.15"].opt_bin

    system "cargo", "install", *std_cargo_args
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
