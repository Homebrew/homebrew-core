class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      :tag      => "0.12.4",
      :revision => "f7c29ea19b5df9d7aa87e9c70aacf4d9315da2cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "984de15cf26b76a91c02ef55d73afc61bae3b57371af780df4cf6b7838ed4716" => :catalina
    sha256 "59b5d952e1cfe35b7f976ff6d669fc17ac578f8ada96e41ee0803b22f1104bd1" => :mojave
    sha256 "4a244f5068a294b36429dfb6f2d60b2e7823c2ab815b10df8a86c5a50e1b9c96" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = "amd64"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/openfaas/faas-cli").install buildpath.children
    cd "src/github.com/openfaas/faas-cli" do
      project = "github.com/openfaas/faas-cli"
      commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
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
