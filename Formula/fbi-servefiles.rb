class FbiServefiles < Formula
  include Language::Python::Virtualenv

  desc "Serve local files to Nintendo 3DS via FBI remote installer"
  homepage "https://github.com/Steveice10/FBI"
  url "https://github.com/Steveice10/FBI/archive/2.5.2.tar.gz"
  sha256 "c4b568f1410859c2567c44c3af66c880210294d75f2dfe09deac04351997a904"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e6d1df54cf7a26852bb41e2126e7b28198f468d9d3e09125ebfd758e029a1151" => :mojave
    sha256 "37f2e02c88c68efdc6d5d4afdb4758c2b353c59b24e32a4b5a29ae64c0860a96" => :high_sierra
    sha256 "1cd570e03e53dafc15394c6a6ae2214d53f3c2c30ac7fe9bae82cf31c1545982" => :sierra
  end

  depends_on "python"

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
