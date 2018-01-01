class FbiServefiles < Formula
  include Language::Python::Virtualenv
  desc "Serve local files to Nintendo 3DS via FBI remote installer"
  homepage "https://github.com/Steveice10/FBI"
  url "https://github.com/Steveice10/FBI/archive/2.4.14.tar.gz"
  sha256 "b8bfd0271eef0da50fe7dbfe3035a52492d1825cbeb831b739bbe1556ce46e0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "204141ebb001cb148f31964c173db1bc8821fad925084b0b30b7268e9a436ea9" => :high_sierra
    sha256 "d3c95040616000b52a1d77b4ebaad28be4bdd5aa93a60ebf7ed6be3ca1229244" => :sierra
    sha256 "d51364f0b41dc8fe567dbfca43231889f7ae3b7ecbac8303a10143a2f298b524" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

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
