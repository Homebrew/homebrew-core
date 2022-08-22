class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.14.6",
      revision: "fcf50cef7b3510d93dd109606fb300705bb509f2"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d099f13ed943b152ff2ebabd6ba8c14ba08ed6dc6259ae835eff2fe07eb9830a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5fa9035963b58294a6b3644d928c3bf457cead51adc0102405ce90f04614a12"
    sha256 cellar: :any_skip_relocation, monterey:       "bcd4d4b755bf82198655eab1874ef044498556d5e576bb3d36d6d3c51d12d487"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec373dbf8b45ec5d303ac0711dfc87d510d8cd3b5b32be879e99463ad0fb5df7"
    sha256 cellar: :any_skip_relocation, catalina:       "753ef830058c7b87a5a573ea60b89f026fcd8856e489b5905e6c246b84c3fd35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5ac093d389cef5167dc87088a41021476e317b3dff6dc23724381e2670b81b6"
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

    (bash_completion/"faas-cli").write Utils.safe_popen_read(bin/"faas-cli", "completion", "--shell", "bash")
    (zsh_completion/"_faas-cli").write Utils.safe_popen_read(bin/"faas-cli", "completion", "--shell", "zsh")
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
