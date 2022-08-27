class Mycorrhiza < Formula
  desc "Lightweight wiki engine with hierarchy support"
  homepage "https://mycorrhiza.wiki"
  url "https://github.com/bouncepaw/mycorrhiza/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "db1a717b01f388ef7424b60a5462c1ca57b6392c9e1f61a668ee14da90e0074f"
  license "AGPL-3.0-only"
  head "https://github.com/bouncepaw/mycorrhiza.git", branch: "master"

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
