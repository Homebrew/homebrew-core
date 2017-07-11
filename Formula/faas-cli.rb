class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "http://docs.get-faas.com/"
  url "https://github.com/alexellis/faas-cli/archive/0.4.tar.gz"
  sha256 "f7ecebde2545243e9f37f7feb9fc2a171585d3f9e7998f981611f038bbc93987"

  bottle do
    cellar :any_skip_relocation
    sha256 "18e22111574976f859575192424af39fcd679fcdc9c39e90a8a38c81e0fca85a" => :sierra
    sha256 "6a863fae58f75a9487e762b5f98430cc329f0df9af1d32d4a463a9048cc81ae8" => :el_capitan
    sha256 "01c0c83ff0ab842ea8402723c8a0b6ff436afb56fffa55e048df9cc3e4c4494e" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/alexellis/faas-cli").install buildpath.children
    cd "src/github.com/alexellis/faas-cli" do
      system "go", "build", "-o", bin/"faas-cli"
      prefix.install_metafiles
    end
  end

  test do
    require "socket"

    server = TCPServer.new("localhost", 0)
    port = server.addr[1]
    pid = fork do
      loop do
        socket = server.accept
        response = "OK"
        socket.print "HTTP/1.1 200 OK\r\n" \
                    "Content-Length: #{response.bytesize}\r\n" \
                    "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end

    (testpath/"test.yml").write <<-EOF.undent
      provider:
        name: faas
        gateway: http://localhost:#{port}
        network: "func_functions"

      functions:
        dummy_function:
          lang: python
          handler: ./dummy_function
          image: dummy_image
    EOF

    expected = <<-EOS.undent
      Deploying: dummy_function.
      Removing old service.
      200 OK
      URL: http://localhost:#{port}/function/dummy_function
    EOS

    begin
      output = shell_output("#{bin}/faas-cli -action deploy -yaml test.yml")
      assert_equal expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
