class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.14.1",
      revision: "d94600d2d2be52a66e0a15c219634f3bcac27318"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "435219b6667d560184d060d7c86f1b2ff03a143231baa1924f3e689d15039f7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6004ec50f64194b4e12461851f30e77277f2bd34ee18f527aaf68cccf002f0d1"
    sha256 cellar: :any_skip_relocation, monterey:       "c273efc9a263dc814e01b77235ba5ea18733e45a3243103a667eb23fc7a7f164"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b084d949a0e2df90d15457e962812240aa36b8bd1306e4eb417387724f564c8"
    sha256 cellar: :any_skip_relocation, catalina:       "383a8e56921825d12c018bff8766d1722e1387fb6bfe410973ecef476c08f6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64f600410435b59160f6d16b2047e625e09910b48a30237bc17ce720f5e64ff7"
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
    system "go", "build", "-ldflags", ldflags.join(" "), "-a", "-installsuffix", "cgo", "-o", bin/"faas-cli"
    bin.install_symlink "faas-cli" => "faas"

    (bash_completion/"faas-cli").write Utils.safe_popen_read("#{bin}/faas-cli", "completion", "--shell", "bash")
    (zsh_completion/"_faas-cli").write Utils.safe_popen_read("#{bin}/faas-cli", "completion", "--shell", "zsh")
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
