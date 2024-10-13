class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli/archive/refs/tags/0.16.37.tar.gz"
  sha256 "dfd3a49e61999bc497c08632566e090231dfbeb5a59d0fb9b4d9a213db83b566"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1fcd51c48ada357c3d8739685fe8b3ea6a155ae6cdae2b8a5bab72248a6043f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1fcd51c48ada357c3d8739685fe8b3ea6a155ae6cdae2b8a5bab72248a6043f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1fcd51c48ada357c3d8739685fe8b3ea6a155ae6cdae2b8a5bab72248a6043f"
    sha256 cellar: :any_skip_relocation, sonoma:        "77956f7fdb5e277eeeb3f38adb4387ca7bf7dc98ab808811ac2b0e7db2b7fb2a"
    sha256 cellar: :any_skip_relocation, ventura:       "77956f7fdb5e277eeeb3f38adb4387ca7bf7dc98ab808811ac2b0e7db2b7fb2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88b1f3eecd8307f1e859d81c8795f86a56a2fa74465a52c2f74b6b45bfb7ddb0"
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

      faas_cli_version = shell_output("#{bin}/faas-cli version")
      assert_match version.to_s, faas_cli_version
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
