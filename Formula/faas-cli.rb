class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.13.15",
      revision: "b562392b12a78a11bcff9c6fca5a47146ea2ba0a"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "098c53bf56e395f3da01359e9f9a41d90978b94619970db54c51ed849af2f305"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3757d79757a49a9d116e2dfd9665c1080f69de976fbee22aae96c91bf7031163"
    sha256 cellar: :any_skip_relocation, monterey:       "4714c4f69ed4e335f72dbd6d02e45a2c7d1399c96e35757d111898ca94b6ada8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7efd0ca1bf78a005d5b6ca1439d7f2db181aa1206cd201c8699fc28eebe8ea83"
    sha256 cellar: :any_skip_relocation, catalina:       "2e5abe26e4b0eae0a0bb2a6d65aa37a0c508cc2845b23d6697433a1835b7de3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47b0e29998140d1f4d6737fac83226132c5155a2b8679265771315859525be46"
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = OS.kernel_name.downcase
    ENV["XC_ARCH"] = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
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
