class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "http://docs.get-faas.com/"
  url "https://github.com/alexellis/faas-cli.git",
      :tag => "0.4.6",
      :revision => "39183ee1b344a7bb8825bd2ebedce5c0bf4262c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "57ecf94c6e61ca56a1ab9c35fd542494248abbede4be867f010c01486fae9f47" => :sierra
    sha256 "f80d2ebd8564816f5d133b5c8a59058c761e0f6cafa066c46ea938cbe9499906" => :el_capitan
    sha256 "974e2513f6d2886adcb856665b9f9f562a75543a2a053a121d246114b1e51eac" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/alexellis/faas-cli").install buildpath.children
    cd "src/github.com/alexellis/faas-cli" do
      commit = Utils.popen_read("git rev-list -1 HEAD").chomp
      system "go", "build", "-ldflags", "-X main.GitCommit=#{commit}", "-a",
             "-installsuffix", "cgo", "-o", bin/"faas-cli"
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
      Deployed.
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
