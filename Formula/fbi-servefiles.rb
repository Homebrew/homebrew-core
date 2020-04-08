class FbiServefiles < Formula
  include Language::Python::Virtualenv

  desc "Serve local files to Nintendo 3DS via FBI remote installer"
  homepage "https://github.com/Steveice10/FBI"
  url "https://github.com/Steveice10/FBI/archive/2.6.0.tar.gz"
  sha256 "4948d4c53d754cc411b51edbf35c609ba514ae21d9d0e8f4b66a26d5c666be68"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "0240fdac4ac0282e980d113b430702d6693b52ec3d98955e4ca8444a6e73638e" => :catalina
    sha256 "307d14a7e492771758ddb6e059eb78c2fb65bbc818b48ebb34c5941e4493e7bd" => :mojave
    sha256 "d92c88a5682ff03bc5221f8c2bab82a5eaad593377f31a21ccb196c444012396" => :high_sierra
    sha256 "b9b755ced8b5387e70181598347ecb790ec4df4454fed8c63d85816864ed1976" => :sierra
  end

  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
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
