class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.16.16",
      revision: "7934de92b73aa169b163e3281d8bdc89e22ada51"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "963c25f36b9050f168d85e93f267989503b5ed621e6e26712ec534cc0e35892f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b7bfa1b8ac1cc427c4d18a48c476ef3f446ede72b89a6437fae23b6d323be40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d7c9e76f3ee188fb7ee7a08e0181da7ddb28564d11d5c1e8ebcc850fe887938"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b2a535d923994dac1000581380d155e4c3fbab80cf4d8a654350fb35cdda1c7"
    sha256 cellar: :any_skip_relocation, ventura:        "6a0d4443c2b2275a5eaca380106934e8e9e2d2d24189e6a0e0d258cd65ff9bc5"
    sha256 cellar: :any_skip_relocation, monterey:       "50a9b1640ed8b60b95765dc575be67c4e506b86e48df371fafd68964eb0188fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c37553910d534dc822caeb9744340a8223b10dde24de3e1346be0d4b68bbdb75"
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
