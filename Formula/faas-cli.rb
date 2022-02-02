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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4234187b651714c864a062c68d610b6f354b7840f3bce5adcec7bf1446ab85fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "514964d9b473ebc0b26eb1d31f1a5efe286d8aca232d0c67922ff0a5dfcab621"
    sha256 cellar: :any_skip_relocation, monterey:       "936eebaf4f203364427d74faeb1b3827420541fee4e3a811af1107ba48f037e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "94c76ead308de480d170b005c1bb515f27af72200924359cced6ba78435677b8"
    sha256 cellar: :any_skip_relocation, catalina:       "0d4fec22d3c1fbdc9a719e8971ac2c02853d5c9830b2298fabeba6c7031108ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cb8944b08b00e685bfb2ac3e5f95100bfd516d1c2839d857ffb7674d3c8c9df"
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
