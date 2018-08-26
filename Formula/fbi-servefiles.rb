class FbiServefiles < Formula
  include Language::Python::Virtualenv

  desc "Serve local files to Nintendo 3DS via FBI remote installer"
  homepage "https://github.com/Steveice10/FBI"
  url "https://github.com/Steveice10/FBI/archive/2.5.2.tar.gz"
  sha256 "c4b568f1410859c2567c44c3af66c880210294d75f2dfe09deac04351997a904"

  bottle do
    cellar :any_skip_relocation
    sha256 "85600e0da8641fb6bd2b1bf22213283b6561c29cba36c4ce56ecdb2cd5c19751" => :mojave
    sha256 "42379c4871147207d8139e603ccf54772595f1874cac623a854bfd92889bba93" => :high_sierra
    sha256 "e0ef0f976b9b83532c6fbf132ec8a2e4c2bb6cfa754f3b4dce6d0d21feae42fe" => :sierra
    sha256 "5127f1f0897a688db30c54aaaca8303e87a7f93cceed9aaf3cb5baba0cdbde72" => :el_capitan
  end

  depends_on "python@2"

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
