class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "http://docs.get-faas.com/"
  url "https://github.com/alexellis/faas-cli/archive/0.4.tar.gz"
  sha256 "f7ecebde2545243e9f37f7feb9fc2a171585d3f9e7998f981611f038bbc93987"

  bottle do
    cellar :any_skip_relocation
    sha256 "10511119a3f28175c2ef1218567f3de0c2b5a6348b19bf3e0ddd76b47f8e168d" => :sierra
    sha256 "71cb387663c38625d0c470c8d9f13d5149c13ab0828a9f0f6ba58fcf0e3dce90" => :el_capitan
    sha256 "65ebcc5d6c95735ada15b51e1b7aeef4a50b71a686889ba490f97ea362206239" => :yosemite
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
