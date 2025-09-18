class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli/archive/refs/tags/0.17.8.tar.gz"
  sha256 "d3f4682295caec6ee2b9fdf3732f9e40d65ff5a09a231af44ae33e71a2eaeaec"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29016e94c7aadf82c5a83d2877e10a4d2d56e693cfec57cd3d085c5b37b43019"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a1d23aa9d79bed280e93a09bdfac2c5182410ad2e5af958ad73f7eb323efe38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a1d23aa9d79bed280e93a09bdfac2c5182410ad2e5af958ad73f7eb323efe38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a1d23aa9d79bed280e93a09bdfac2c5182410ad2e5af958ad73f7eb323efe38"
    sha256 cellar: :any_skip_relocation, sonoma:        "5167a68a692e77a38e01000dca1cf27f164856933cde0954cc1b75fbf2d71063"
    sha256 cellar: :any_skip_relocation, ventura:       "5167a68a692e77a38e01000dca1cf27f164856933cde0954cc1b75fbf2d71063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d686963ec51c5142d84f81aa7c4bd2cd9a221041b05bd1fc7c6de03f07593dd"
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
