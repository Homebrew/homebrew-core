class Mycorrhiza < Formula
  desc "Lightweight wiki engine with hierarchy support"
  homepage "https://mycorrhiza.wiki"
  url "https://github.com/bouncepaw/mycorrhiza/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "db1a717b01f388ef7424b60a5462c1ca57b6392c9e1f61a668ee14da90e0074f"
  license "AGPL-3.0-only"
  head "https://github.com/bouncepaw/mycorrhiza.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36c2d17e005bf69070d82ef3ff8f19d90e5ae9c8cf9cb8957c3822292e07bedc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "285db6811ec3ada179514a4bd3a427dca0df4cfe1f34e2734c1c6db6511c382d"
    sha256 cellar: :any_skip_relocation, monterey:       "22227f813f2890cdea199a784f372bd5506689ecc382bb8ccf2c8babd1f22350"
    sha256 cellar: :any_skip_relocation, big_sur:        "033ec3b22f68f5fdec98a2893c090d7f80a20b07a6a2f601930d714ad1d997ab"
    sha256 cellar: :any_skip_relocation, catalina:       "48a2eac664f134599e9895bdc69f1fa9ea95fd676bdf2da852d8df0f8cd5473a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6f98d8f578105bdf4120d547464d28a2f45f949a38d4dff55625dddf95a1e0f"
  end

  depends_on "go" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  service do
    run [opt_bin/"mycorrhiza", var/"lib/mycorrhiza"]
    keep_alive true
    log_path var/"log/mycorrhiza.log"
    error_log_path var/"log/mycorrhiza.log"
  end

  test do
    # Find an available port
    port = free_port

    pid = fork do
      exec bin/"mycorrhiza", "-listen-addr", "127.0.0.1:#{port}", "."
    end

    # Wait for Mycorrhiza to start up
    sleep 5

    # Create a hypha
    cmd = "curl -siF'text=This is a test hypha.' 127.0.0.1:#{port}/upload-text/test_hypha"
    assert_match(/303 See Other/, shell_output(cmd))

    # Verify that it got created
    cmd = "curl -s 127.0.0.1:#{port}/hypha/test_hypha"
    assert_match(/This is a test hypha\./, shell_output(cmd))
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
