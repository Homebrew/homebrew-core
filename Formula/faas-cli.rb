class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.12.14",
      revision: "c12d57c39ac4cc6eef3c9bba2fb45113d882432f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7051bca10bfdfd1ef4e7fe687494eecf5df77827a44a08c94cba9f4851e52120" => :catalina
    sha256 "bdca47be1908c16bcf727414edfcfb6a17b959e4b426ac793c3afbfc2e167aa2" => :mojave
    sha256 "cfd299020e90768c1ad8536ef1be86b0f882d206524866f89f82bffc58a39fc0" => :high_sierra
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
