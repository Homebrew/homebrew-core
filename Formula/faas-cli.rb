class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.12.21",
      revision: "598336a0cad38a79d5466e6a3a9aebab4fc61ba9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d315d6e973ff51cdc45f80d80d1d6c97f116209f2846321a6717191ea0618b22" => :big_sur
    sha256 "f367b80343e7d3287e7b8cdb5d26bc21d6b8cdd1cbd321b1ec19db0e41495b81" => :catalina
    sha256 "fcf8712bedfd506e1d654b3b29fc4b6b935f627ad8f49c89e2fd5b63026434c4" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = "amd64"
    project = "github.com/openfaas/faas-cli"
    commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    system "go", "build", "-ldflags",
            "-s -w -X #{project}/version.GitCommit=#{commit} -X #{project}/version.Version=#{version}", "-a",
            "-installsuffix", "cgo", "-o", bin/"faas-cli"
    bin.install_symlink "faas-cli" => "faas"
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
        gateway: https://localhost:#{port}
        network: "func_functions"

      functions:
        dummy_function:
          lang: python
          handler: ./dummy_function
          image: dummy_image
    EOS

    begin
      output = shell_output("#{bin}/faas-cli deploy --tls-no-verify -yaml test.yml 2>&1", 1)
      assert_match "stat ./template/python/template.yml", output

      assert_match "ruby", shell_output("#{bin}/faas-cli template pull 2>&1")
      assert_match "node", shell_output("#{bin}/faas-cli new --list")

      output = shell_output("#{bin}/faas-cli deploy --tls-no-verify -yaml test.yml", 1)
      assert_match "Deploying: dummy_function.", output

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
