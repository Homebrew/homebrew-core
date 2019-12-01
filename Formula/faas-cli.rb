class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://docs.get-faas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      :tag      => "0.11.0",
      :revision => "0ab4012784510381e2b90c031ede3d77197b10b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "6075dc7f30879b00eaf0a10eda06825c19f094d77c89913a8561f9348a928fc1" => :catalina
    sha256 "7f94c376c1cfb8142afd73bc117b860d7190d4eb3bc018de46c67eeb17c74e6a" => :mojave
    sha256 "6595e8d4ffe9aafe1e0a7c58298615c3fd3aa9040c9a8ef26a18b4ffbbbc34b4" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = "amd64"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/openfaas/faas-cli").install buildpath.children
    cd "src/github.com/openfaas/faas-cli" do
      project = "github.com/openfaas/faas-cli"
      commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
      system "go", "build", "-ldflags",
             "-s -w -X #{project}/version.GitCommit=#{commit} -X #{project}/version.Version=#{version}", "-a",
             "-installsuffix", "cgo", "-o", bin/"faas-cli"
      bin.install_symlink "faas-cli" => "faas"
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
        name: openfaas
        gateway: http://localhost:#{port}
        network: "func_functions"

      functions:
        dummy_function:
          lang: python
          handler: ./dummy_function
          image: dummy_image
    EOS

    begin
      output = shell_output("#{bin}/faas-cli deploy -yaml test.yml 2>&1", 1)
      assert_match "stat ./template/python/template.yml", output

      assert_match "ruby", shell_output("#{bin}/faas-cli template pull 2>&1")
      assert_match "node", shell_output("#{bin}/faas-cli new --list")

      output = shell_output("#{bin}/faas-cli deploy -yaml test.yml")
      assert_match "Function dummy_function already exists, attempting rolling-update", output
      assert_match "Deployed. 200 OK", output

      stable_resource = stable.instance_variable_get(:@resource)
      commit = stable_resource.instance_variable_get(:@specs)[:revision]
      faas_cli_version = shell_output("#{bin}/faas-cli version")
      assert_match /\s#{commit}$/, faas_cli_version
      assert_match /\s#{version}$/, faas_cli_version
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
