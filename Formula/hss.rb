class Hss < Formula
  desc "Interactive parallel ssh client featuring autocomplete and asynchronous"
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/1.6.tar.gz"
  sha256 "8516f3e24c9908f9c7ac02ee5247ce78f2a344e7fcca8a14081a92949db70049"
  head "https://github.com/six-ddc/hss.git"

  depends_on "readline"

  def install
    system "make"
    system "make", "install", "INSTALL_BIN=#{bin}"
  end

  test do
    begin
      nc_read, nc_write = IO.pipe
      nc_pid = fork do
        exec "nc", "-4l", "9527", :out => nc_write
      end
      hss_read, hss_write = IO.pipe
      hss_pid = fork do
        exec "#{bin}/hss", "-H", "-p 9527 127.0.0.1", "-u", "root", "true", :out => hss_write
      end
      msg = nc_read.gets
      assert_match "SSH", msg
      Process.kill("TERM", nc_pid)
      msg = hss_read.gets
      assert_match "Connection closed by remote host", msg
    ensure
      Process.kill("TERM", nc_pid)
      Process.kill("TERM", hss_pid)
    end
  end
end
