class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli/archive/refs/tags/0.18.3.tar.gz"
  sha256 "2f090946d3de55a5f32021658d0971271e196ea88b43f78b9c2bd45af901f4c6"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f79bf57d24958dcc28d605c77cb28a19dc0458956e16f85900b9205f841f24d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f79bf57d24958dcc28d605c77cb28a19dc0458956e16f85900b9205f841f24d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f79bf57d24958dcc28d605c77cb28a19dc0458956e16f85900b9205f841f24d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c432886dac017a98c9724d559c8e9d64e965345a833c35e69f4d3df901edca93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05b148d700ef381ca20a0e3b853279bb90c7b5033e7e0294c72d827001329e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "775f8b09ca8720de999af4403615f07c586e62c7d2545a8ca1cf6426fc9178dd"
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
