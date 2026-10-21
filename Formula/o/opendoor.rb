class Opendoor < Formula
  include Language::Python::Virtualenv

  desc "CLI for web reconnaissance, directory discovery, and exposure assessment"
  homepage "https://github.com/stanislav-web/OpenDoor"
  url "https://files.pythonhosted.org/packages/9b/67/f05f0d3a4c2aaea9651d348ddd196ecb84965e2d50586dc08e1a2f649b0d/opendoor-5.18.0.tar.gz"
  sha256 "f912e876b57b5416bcd1bb9423d74f7440f1366e0289877609e5dd0a8a2b3d67"
  license "GPL-3.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "019f22d6e8a7629e5def6a7efe5cd216ba237b2270eaf12ddf0ffb742921a720"
  end

  depends_on "python@3.15"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  # Apply open PR to update urllib3 pin so that metadata is aligned
  patch do
    url "https://github.com/stanislav-web/OpenDoor/commit/24700704fffbf2778742a4d6b426dbd1e16772bc.patch?full_index=1"
    sha256 "3543ac90478118ea55ff4918b91a9ad3bb445298ac489f862ec4b975d4423e8c"
    type :unofficial
    resolves "https://github.com/stanislav-web/OpenDoor/pull/134"
  end

  # Python 3.15 runtime support, upstream PR ref, https://github.com/stanislav-web/OpenDoor/pull/135
  patch do
    url "https://github.com/stanislav-web/OpenDoor/commit/213bff67f0d777edbba79e28ffcdbe92fd767594.patch?full_index=1"
    sha256 "13940d730310fd00802a9c5262999065c13cad7c6a52dd2c6eb49c74a171b477"
    type :unofficial
    resolves "https://github.com/stanislav-web/OpenDoor/pull/135"
  end

  def install
    venv = virtualenv_install_with_resources

    # Build :all bottle
    %w[base openvpn wireguard].each do |f|
      file = venv.site_packages/"src/core/network/adapters/#{f}.py"
      inreplace file, "/usr/local", HOMEBREW_PREFIX
      inreplace file, "/opt/homebrew", HOMEBREW_PREFIX
    end
    inreplace venv.site_packages/"src/core/core.py", "/usr/local", HOMEBREW_PREFIX
    inreplace venv.site_packages.glob("opendoor-*.dist-info/METADATA"), "/opt/homebrew", HOMEBREW_PREFIX
    inreplace libexec/"opendoor.conf", "/opt/homebrew", HOMEBREW_PREFIX
  end

  test do
    require "socket"

    system libexec/"bin/python", "-m", "pip", "check"

    server = TCPServer.new("127.0.0.1", 0)
    port = server.addr[1]
    wordlist = testpath/"wordlist.txt"

    wordlist.write ["opendoor-health.txt", "missing-opendoor.txt", ""].join(10.chr)

    server_pid = fork do
      loop do
        socket = server.accept
        begin
          request = socket.gets("\r\n\r\n")
          next unless request

          found = request.lines.first.split[1] == "/opendoor-health.txt"
          status = found ? "200 OK" : "404 Not Found"
          body = found ? "ok" : "not found"
          socket.print "HTTP/1.1 #{status}\r\nContent-Length: #{body.bytesize}\r\nConnection: close\r\n\r\n#{body}"
        ensure
          socket.close
        end
      end
    end
    output = begin
      shell_output(
        "#{bin}/opendoor --host 127.0.0.1 --port #{port} --scheme http:// " \
        "--scan directories --method GET --wordlist #{wordlist} " \
        "--threads 1 --include-status 200 --debug -1 2>&1",
      )
    ensure
      Process.kill("TERM", server_pid)
      Process.wait(server_pid)
    end

    assert_match "opendoor-health.txt", output
    refute_match "missing-opendoor.txt", output
  end
end
