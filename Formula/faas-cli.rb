class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.14.2",
      revision: "b1c09c0243f69990b6c81a17d7337f0fd23e7542"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b197e7951b280b0125279c548c341f0a481969404b507e8568bb05dbf4f1873"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b8f57004967cc1dd861813be1ddf1efb9d23e7df1eb5738bcacfb91f5714c62"
    sha256 cellar: :any_skip_relocation, monterey:       "737b74b5de03f6f6edd6504a9f8c71ce3459894178a418084016de7933cbe393"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5725f4499fc6166cc463c769cfcca27bd760e9c6a44ffb6b795acd9fb6ce740"
    sha256 cellar: :any_skip_relocation, catalina:       "28f0b2b275a2e35a57c06d50e2eb8f1f991e365a9cc28a9b55c5635f265b3790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eff9b23ae2028d8b3e5f116d5815c02cacb23ccac61bd96e5dae10d770f871a"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

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
