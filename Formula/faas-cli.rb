class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://docs.get-faas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      :tag      => "0.9.2",
      :revision => "893972afffa5ea6672faa6e11743ae46322ec58c"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b3435b6efee3f0e13be4a80361c4e35df0e4a041630984fc53d584f2d30c4c8" => :mojave
    sha256 "829b45235d21a3b00365d741f9846ee8b1800ffd1965a244cb2e6c1a97ef2d06" => :high_sierra
    sha256 "b46a6eb55068e8dd9b462e7671d22da008b1f8b46a7a74a6ce26e95bda225c90" => :sierra
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
        name: faas
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
