class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "http://docs.get-faas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      :tag => "0.4.31",
      :revision => "5eac30a84ce41603527cab8decb716f45eaeb40b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1f495a72f8b3bab6869c15f6ef22fe96037406d18ddb3e00fe19634ba9fc8c0" => :high_sierra
    sha256 "3875c3b12c68ecc78d22733a01d104bf516a39dcb0a1ebb13bbb1eb51445e17c" => :sierra
    sha256 "aa68d57074f8ae5d12ae2797a3b41278cd56539706b8a775f787a9405c97bcd8" => :el_capitan
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
      Removing old function.
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
