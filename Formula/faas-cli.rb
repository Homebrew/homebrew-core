class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.15.4",
      revision: "0074051aeb837f5f160ee8736341460468b5c190"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62513fceaddc66b8ff066bcb9aed4eade7bdeeded5a63ab4db57c0f955fc3c34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08d5acfca1b93952a081d5baf5d3ceda155aeffd27ef2218f09621436da5c9c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6724bf8cdc5f8f8619763db31b2c1e6481afa4eade0b747cba5b6749b1c5bea"
    sha256 cellar: :any_skip_relocation, ventura:        "2bf1aa3e8ac6cac12601d3987cf8b8eb933494d4a3928242299145ce3e98233e"
    sha256 cellar: :any_skip_relocation, monterey:       "c56f192ee328325863e6760a0f5ec47d7199943ffed73b8abbfb5aa650e39d16"
    sha256 cellar: :any_skip_relocation, big_sur:        "f45e25a6fc6b4533855fbd7a28af661f5ed7eb2dbfaf08f6fc7dd7dec0ff6e3c"
    sha256 cellar: :any_skip_relocation, catalina:       "a44b26ede29570966e1b0a5c2b0d848667978852f3fe74de790e49d88c8c0ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cbacd19e5239d1ac2b06c89cf0c25e7604ab6251d1c349431986f67b0d91044"
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
