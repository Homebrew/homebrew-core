class FbiServefiles < Formula
  include Language::Python::Virtualenv
  desc "Serve local files to Nintendo 3DS via FBI remote installer"
  homepage "https://github.com/Steveice10/FBI"
  url "https://github.com/Steveice10/FBI/archive/2.4.14.tar.gz"
  sha256 "b8bfd0271eef0da50fe7dbfe3035a52492d1825cbeb831b739bbe1556ce46e0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0065f2be62f713c4200dabbf528fbc1d50d206efe7c6b03cfc1f73c1213723b1" => :high_sierra
    sha256 "8f68dde6bf8594d3e9f47bf6e39dd4b427bcc733f3a383075bdc9934efe3e0e9" => :sierra
    sha256 "fb14ed2b7103bc58d79da73cb7ab150da741bdbbf12dea007233327520d8b5b2" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install_and_link buildpath/"servefiles"
  end

  test do
    require "socket"

    def test_socket
      server = TCPServer.new(5000)
      client = server.accept
      client.puts "\n"
      client_response = client.gets
      client.close
      server.close
      client_response
    end

    begin
      pid = fork do
        system "#{bin}/sendurls.py", "127.0.0.1", "https://github.com"
      end
      assert_match "https://github.com", test_socket
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    begin
      touch "test.cia"
      pid = fork do
        system "#{bin}/servefiles.py", "127.0.0.1", "test.cia", "127.0.0.1", "8080"
      end
      assert_match "127.0.0.1:8080/test.cia", test_socket
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
