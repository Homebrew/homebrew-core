class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "http://docs.get-faas.com/"
  url "https://github.com/alexellis/faas-cli.git",
      :tag => "0.4.14",
      :revision => "a2c488e389dade9dc4f609dda87f15c8e74e79ec"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba4a2401c54137c90caf7b171ba0e62be3c80d5032c64c20828d90f2a3b57126" => :sierra
    sha256 "cdf45455053ae82473ff32a3bedc2c737cc0a43cd993be0ee8afb55fc366d091" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/alexellis/faas-cli").install buildpath.children
    cd "src/github.com/alexellis/faas-cli" do
      commit = Utils.popen_read("git rev-list -1 HEAD").chomp
      system "go", "build", "-ldflags", "-s -w -X github.com/alexellis/faas-cli/commands.GitCommit=#{commit}", "-a",
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
      output = shell_output("#{bin}/faas-cli deploy -yaml test.yml")
      assert_equal expected, output.chomp

      commit = Utils.popen_read("git rev-list -1 HEAD").chomp
      output = shell_output("#{bin}/faas-cli version")
      assert_match commit, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
