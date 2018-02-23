class FbiServefiles < Formula
  include Language::Python::Virtualenv
  desc "Serve local files to Nintendo 3DS via FBI remote installer"
  homepage "https://github.com/Steveice10/FBI"
  url "https://github.com/Steveice10/FBI/archive/2.5.0.tar.gz"
  sha256 "e28e62e906aad30d9894bb875905d5c532df980103a8603df8c0a9bfbf8f9544"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf639c9734a1ae31d6b699d16dd2e385dcb299b270cd58a370056e74695ecad3" => :high_sierra
    sha256 "87f57b317f8da416795cad01c810a9a6bd902ae3c2d629669eb6c880b31fe828" => :sierra
    sha256 "567ba0e6e5470c47832d4acfd7a2b61adfece4758e847a7c83955e9973aee16b" => :el_capitan
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
