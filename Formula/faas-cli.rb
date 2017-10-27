class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "http://docs.get-faas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      :tag => "0.4.19c",
      :revision => "baa728fbc5d85c439cc35393c905b9437604e06b"
  version "0.4.19c"

  bottle do
    cellar :any_skip_relocation
    sha256 "36518bf1298645eaa16a7c0f3075c22cbdef25b35a9849a18d26fcdeb9a19e09" => :high_sierra
    sha256 "25c42b9a8d67c4af328668138a5fab47e3b984d85a0ab0c1ad19dd5e0e08ed2f" => :sierra
    sha256 "8eee9cfea4de50b14114472ea26fae1899a6b2d2e37cc0e81986112989699ad4" => :el_capitan
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

    (testpath/"test.yml").write <<~EOS
      provider:
        name: faas
        gateway: http://localhost:#{port}
        network: "func_functions"

      functions:
        dummy_function:
          lang: python
          handler: ./dummy_function
          image: dummy_image
    EOS

    expected = <<~EOS
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
