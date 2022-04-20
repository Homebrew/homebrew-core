class MicroInetd < Formula
  desc "Simple network service spawner"
  homepage "https://acme.com/software/micro_inetd/"
  url "https://acme.com/software/micro_inetd/micro_inetd_14Aug2014.tar.gz"
  version "2014-08-14"
  sha256 "15f5558753bb50ed18e4a1445b3e8a185f3b1840ec8e017a5e6fc7690616ec52"
  license "BSD-2-Clause"

  uses_from_macos "netcat" => :test

  def install
    bin.mkpath
    man1.mkpath
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"micro_inetd", port.to_s, "/bin/echo", "OK"
    end

    # wait for server to be running
    sleep 1

    assert_equal "OK", shell_output("nc localhost #{port}").strip
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
