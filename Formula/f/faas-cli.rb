class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.16.23",
      revision: "a3e72b5881c4efcc7a366a2e8dc384399c807dfc"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "908a724b718946295d7e6212accc5770052ebea4a8e7c9199d8c34da8c43176c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fcacd27058379c4d9bb9a2d5667cf53ffda72ebe154fcaff06dda11c98a4072"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf9e2626a0d7edde1eafabd8c6a908b4a11451c1a75b9bea657e88629b3e251a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cd9f036ab41d1d3a37f0673fe43f842d07273aa38b38276fe5cc8e56215c9cb"
    sha256 cellar: :any_skip_relocation, ventura:        "400c97a596883a8b6fe897bdd043e3cb5a4d1dca67888c4accb7e0fb17ca0f11"
    sha256 cellar: :any_skip_relocation, monterey:       "5941ba9d33d0ad89e9ff3ebc62952ff56a3ac0e465b5d42aa3804caf67b64d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8964a02364ed7281437d404046b3c7366bcc019a38902c06bb887255b635d81"
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
