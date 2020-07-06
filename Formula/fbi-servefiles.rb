class FbiServefiles < Formula
  include Language::Python::Virtualenv

  desc "Serve local files to Nintendo 3DS via FBI remote installer"
  homepage "https://github.com/Steveice10/FBI"
  url "https://github.com/Steveice10/FBI/archive/2.6.0.tar.gz"
  sha256 "4948d4c53d754cc411b51edbf35c609ba514ae21d9d0e8f4b66a26d5c666be68"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d04625bf981ccec4ad79cc872fa7eefcd2cadbdf4b62b09f6d5e4e692325b2d5" => :catalina
    sha256 "2654398f6f8d65a5f24371a32c9f11f1bb5b02ce309056b9e9a13d38dbac2fc0" => :mojave
    sha256 "b0aae581bf9247f6e282df341dfcffed362587539e7a443433d376319837961f" => :high_sierra
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
