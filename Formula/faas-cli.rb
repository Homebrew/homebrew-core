class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.13.5",
      revision: "ec002af3c1ef848c507080a83a4e5c6ec6dab308"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "69c28ca760310baa32cbfa569436f1dd3ad1cefcea84e4945f933461d5bad274"
    sha256 cellar: :any_skip_relocation, big_sur:       "f5667bdf94b31288bdd20c989f8dc7e987b74a7fbd40404b21a57a10d0450994"
    sha256 cellar: :any_skip_relocation, catalina:      "291d54b63018a5bacb4f6049f376bfd95bc6cadcb83fee8bf597f5a37112be96"
    sha256 cellar: :any_skip_relocation, mojave:        "0cbe64a557e742daf8173e12c1b6cf5627f86b7a6ebffd133202e9a6fc2a4380"
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = "amd64"
    project = "github.com/openfaas/faas-cli"
    ldflags = %W[
      -s -w
      -X #{project}/version.GitCommit=#{Utils.git_head}
      -X #{project}/version.Version=#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), "-a", "-installsuffix", "cgo", "-o", bin/"faas-cli"
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

      commit_regex = /[a-f0-9]{40}/
      faas_cli_version = shell_output("#{bin}/faas-cli version")
      assert_match commit_regex, faas_cli_version
      assert_match version.to_s, faas_cli_version
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
