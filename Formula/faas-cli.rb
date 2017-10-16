class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "http://docs.get-faas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      :tag => "0.4.18d",
      :revision => "246f5bc0ac830462b2dc5c26462b7705fd4844b1"
  version "0.4.18d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e7c88d74ebf2bb1f95d2276d33b9c53827253e704914d4cd632de9bb0bbd517" => :high_sierra
    sha256 "0b200df5c4a9e3d77c58414bf9338539db3d53842664425c18d305aa4866d57e" => :sierra
    sha256 "cf8b6314e354363dd4c423a4898ee7adc0fc23f412ca3d6620e3057799cfdf0e" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/openfaas/faas-cli").install buildpath.children
    cd "src/github.com/openfaas/faas-cli" do
      commit = Utils.popen_read("git rev-list -1 HEAD").chomp
      system "go", "build", "-ldflags", "-s -w -X github.com/openfaas/faas-cli/commands.GitCommit=#{commit}", "-a",
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
      URL: http://localhost:#{port}/function/dummy_function

      200 OK
    EOS

    begin
      output = shell_output("#{bin}/faas-cli deploy -yaml test.yml")
      assert_equal expected, output

      commit = Utils.popen_read("git rev-list -1 HEAD").chomp
      output = shell_output("#{bin}/faas-cli version")
      assert_match commit, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
