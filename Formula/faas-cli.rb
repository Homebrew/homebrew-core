class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.15.2",
      revision: "addf6bb9866689e0f5a862caf49c60dac06152fb"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8cfbd1a539f778f6448a378788f5550728dff0956cc72bbe45ebcdca5ff050d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbe35a25557fb6892fbc7fccedc38ef1ce82bb7386833cfdb8b799e9fbcf3466"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04f50927e961e66814de210ac7bf0deb798ea0e0bcc19886a651b6ccb6ff0ca6"
    sha256 cellar: :any_skip_relocation, monterey:       "542d0bb7109174c47fe7839d4cdce0443bd52750203a0b6e47136b8d55ec7816"
    sha256 cellar: :any_skip_relocation, big_sur:        "1de607711a26056d3fbe9450aa573a80553b6b61857094c5eb25f5c0e7129355"
    sha256 cellar: :any_skip_relocation, catalina:       "f8b836f65200b806c141fe96bc4625327fad0218b225e65b6f6dca06a3de9290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a587180131218e2e9abc485ab1efc9285873e697c0a23bdce7560a3091227c1a"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-a", "-installsuffix", "cgo"
    bin.install_symlink "faas-cli" => "faas"

    generate_completions_from_executable(bin/"faas-cli", "completion", "--shell", shells: [:bash, :zsh])
    # make zsh completions also work for `faas` symlink
    inreplace zsh_completion/"_faas-cli", "#compdef faas-cli", "#compdef faas-cli\ncompdef faas=faas-cli"
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
