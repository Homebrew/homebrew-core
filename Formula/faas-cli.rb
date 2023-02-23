class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.16.0",
      revision: "5c6e347e88fb1e9fa46d7906ae8d6dcc33b1c79b"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7123d6ad4efdd2f57b9d122f8b21d8c892ae5b0e80fa15b39f9a4203688291bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e33551845aa2660d88dd0079162c0033e41238eb22e829e7a1f7fdb5cde09a40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93fae6db6da734a250d187b2fb240be2198b01b7a8aca49691ea61e2a1620465"
    sha256 cellar: :any_skip_relocation, ventura:        "e68c5da1c695e0236f4ea4011695502e0accbd1e4b6c070a6886eab34c63456f"
    sha256 cellar: :any_skip_relocation, monterey:       "8b6483b946dbd965706ac91de363dbeb5d3dbe5b6baf5d15b2815f9d592d6027"
    sha256 cellar: :any_skip_relocation, big_sur:        "b414cb8cd590cb04d94e8a7b2092fd49001b2ace35951a62c55e96b7c8719f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9e5caeda50b936f1fb4b71e115d789bd05817d79f25c4738d615b1b64690f56"
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
