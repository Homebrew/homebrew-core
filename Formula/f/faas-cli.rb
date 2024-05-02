class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.16.26",
      revision: "a9a775760ba88f37820e2939f5c5f24311f5d45c"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa914359651d6cbbe60a97042dc5dbca648df722ce7faa8a46bf049d2a94518b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66c5ba0689e749e0ab775cee4af1d2679ac37d50c2866312a3a86702e0e871b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e8b517c9cc513dbcd979f5c706fced8f877bd465944e596c4170b3d81191548"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e6be1bdd76d285bed61083d9d2c5047ed70e9bf392080a91509ee5449d6e1b9"
    sha256 cellar: :any_skip_relocation, ventura:        "5d7e87391a9f475ed86d2d7e203d2a16b81af4a49acb28d375709a850548e522"
    sha256 cellar: :any_skip_relocation, monterey:       "3840ea4867020d5c617e3c70f9f632f98d92697bfb993a1c06c5608fdc7877d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99c55786f7142958c892c7d8c49be17633f0d53a13e0e45a772aae29e27d3cea"
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
