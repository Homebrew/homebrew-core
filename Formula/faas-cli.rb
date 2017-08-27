class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "http://docs.get-faas.com/"
  url "https://github.com/alexellis/faas-cli.git",
      :tag => "0.4.8",
      :revision => "893b5c5f6c7d68c89141e813e75de7e0475e8dfc"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4b115999b7d32d5d9a3777287f8995909f09804d3fd70f340441864b18d9afe" => :sierra
    sha256 "ce37113ff33628bce3969d197bd0c548c2e82fcd500e92867e3964220d48eb34" => :el_capitan
    sha256 "f58427ac3600197d9a768351d055d1770b20309c0f24ee39a9933b29182c7117" => :yosemite
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
