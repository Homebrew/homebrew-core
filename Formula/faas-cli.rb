class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.13.9",
      revision: "2cec97955a254358de5443987bedf8ceee272cf8"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab1d53328d0fdac8c2bd7d573d83802d813baca9ea3851028957378d0d1f07a6"
    sha256 cellar: :any_skip_relocation, big_sur:       "64d0ac9b1dd6adc0ec65db4b964665049ae25753b80eb27a1ea285077f42aec3"
    sha256 cellar: :any_skip_relocation, catalina:      "84993602a3a414e58bb0cfdc89fe9bd10d5a6798e0648c900ef6ba8404024b62"
    sha256 cellar: :any_skip_relocation, mojave:        "fe89007a4997b4a7d4f8d8a138277b179ef207ef636534953e4ce042a6d63d2a"
  end

  depends_on "go" => :build

  def install
    os = "darwin"
    on_linux do
      os = "linux"
    end
    ENV["XC_OS"] = os
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
