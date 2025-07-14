class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli/archive/refs/tags/0.17.5.tar.gz"
  sha256 "8bcb708e411ac8fa2817000451599361c3ebe50c993355f0de5c40b98952581b"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0b50c84a1d973c1a0f87e5d9c83f58c2d358bf340a48cdce6e337a2b2c9e865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0b50c84a1d973c1a0f87e5d9c83f58c2d358bf340a48cdce6e337a2b2c9e865"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0b50c84a1d973c1a0f87e5d9c83f58c2d358bf340a48cdce6e337a2b2c9e865"
    sha256 cellar: :any_skip_relocation, sonoma:        "79de4a7e523535949d6f22ba1ed9a45fc9af81a26698fe6af3ab9ef48d5205ae"
    sha256 cellar: :any_skip_relocation, ventura:       "79de4a7e523535949d6f22ba1ed9a45fc9af81a26698fe6af3ab9ef48d5205ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11428d46cccdba5917bab8401a5fa5dd8ccbef2fcd4bd74284a7de9e2e672437"
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = OS.kernel_name.downcase
    ENV["XC_ARCH"] = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    project = "github.com/openfaas/faas-cli"
    ldflags = %W[
      -s -w
      -X #{project}/version.GitCommit=
      -X #{project}/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "-a", "-installsuffix", "cgo"
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

    (testpath/"test.yml").write <<~YAML
      provider:
        name: openfaas
        gateway: https://localhost:#{port}
        network: "func_functions"

      functions:
        dummy_function:
          lang: python
          handler: ./dummy_function
          image: dummy_image
    YAML

    begin
      output = shell_output("#{bin}/faas-cli deploy --tls-no-verify -yaml test.yml 2>&1", 1)
      assert_match "stat ./template/python/template.yml", output

      assert_match "dockerfile", shell_output("#{bin}/faas-cli template pull 2>&1")
      assert_match "node20", shell_output("#{bin}/faas-cli new --list")

      output = shell_output("#{bin}/faas-cli deploy --tls-no-verify -yaml test.yml", 1)
      assert_match "Deploying: dummy_function.", output

      faas_cli_version = shell_output("#{bin}/faas-cli version")
      assert_match version.to_s, faas_cli_version
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
