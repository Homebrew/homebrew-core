class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.16.27",
      revision: "6e26edd4f9ae0d0fac9d6916a1b831f4f41d8096"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee31a49cb401adad0872a88186130e6db96f171339931cbab7e675f9d20ac6d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d70b39809c5093ebbbcea5f6e7e7d4faebbf5e6b749a3a005de99e049075b917"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74e26d6969517a4fad89f4a8c1199cec01b311109283eb9cfc0879df65fc2cf3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f25fddf6007d1ac9e3d07e726e030c668b8e9154798f21b66b8839d418ab07c0"
    sha256 cellar: :any_skip_relocation, ventura:        "cd9088eccbf36175cb53c6dac97fa50bf546f6e0022b8571d3335149dfa3b6a2"
    sha256 cellar: :any_skip_relocation, monterey:       "45706f33d05734316b56e521fcd3803ca9b0b2c17f295b923f95a172b1cd2e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c643feeaafa74171e8a51c8e36dab29a01d938df85a3ddc87ff04c678baaaf6e"
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
