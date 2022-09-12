class FbiServefiles < Formula
  include Language::Python::Virtualenv

  desc "Serve local files to Nintendo 3DS via FBI remote installer"
  homepage "https://github.com/Steveice10/FBI"
  url "https://github.com/Steveice10/FBI/archive/2.6.0.tar.gz"
  sha256 "4948d4c53d754cc411b51edbf35c609ba514ae21d9d0e8f4b66a26d5c666be68"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "82a491cce1b13428f44e1bd6984195dc565b654983376327e0fdbdd28985fd02"
    sha256 cellar: :any_skip_relocation, big_sur:       "54051b80718b8f581397ea1e58b76161dfabafc6de4a113dd715d422a2a12c02"
    sha256 cellar: :any_skip_relocation, catalina:      "54051b80718b8f581397ea1e58b76161dfabafc6de4a113dd715d422a2a12c02"
    sha256 cellar: :any_skip_relocation, mojave:        "54051b80718b8f581397ea1e58b76161dfabafc6de4a113dd715d422a2a12c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "093d05e4e564d7dbc6bc426f573389b5ee9d20312f6be354e5dc27f1d9be08bc"
  end

  disable! date: "2022-07-31", because: :repo_archived

  depends_on "python@3.10"

  def install
    venv = virtualenv_create(libexec, "python3.10")
    venv.pip_install_and_link buildpath/"servefiles"
  end

  def test_socket
    server = TCPServer.new(5000)
    client = server.accept
    client.puts "\n"
    client_response = client.gets
    client.close
    server.close
    client_response
  end

  test do
    require "socket"

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
