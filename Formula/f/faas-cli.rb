class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.16.14",
      revision: "d12888b56367056c23ae14082428bd53ba3dfcb0"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fc5873a722e8b2749ba49240dbdd43209b5c2e5e7624fb3e982d1e4e2ca127c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "804414eec9129f5a52fda9a14186507c608632bf3b31a701227678c316cb2a73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4022aa0c49bc51938673247c697ab69f6e47ced2bff42a4af29f3d1771fe3868"
    sha256 cellar: :any_skip_relocation, ventura:        "187ede3e425b4221f31331231034f9d4a325e1f1aad74f41b287e09dd179395b"
    sha256 cellar: :any_skip_relocation, monterey:       "bf71ba2460bfb84d84c06d47f51a0fa417a3334e2300effed0d3f11ce972ca0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bda8cda35059d4d1c03ffc64c6d9620d04cdf8a79542ee80d1b646964aaf5e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95534c90d0be8ef093d9f93a1e395e6ffb96a67d1552aa92dc2b681c47ab0eb8"
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
