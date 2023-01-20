class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.15.6",
      revision: "fea2bf5a6d0c4bd13bf3f98c36d94f93bf0fd004"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "401cfcecbe0fadf09f68a5be0b23f0d1aa99ba8a364ccea97fab87e41423e514"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7e0ae6e32f0c8e7cea0c0e18383a30dbc05badb656a5d78f199f599fa96c819"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6d7d8f717c9374dd4a8d81a4d62628ada703093c6a852d9e9e6c0557d87ed9d"
    sha256 cellar: :any_skip_relocation, ventura:        "10650ad29ebe3c4ca9d879f0b07589da644ab53a2b69ec74f7740d1a67e80275"
    sha256 cellar: :any_skip_relocation, monterey:       "de653e85a9f697cad5ab90ebedece133804a0cd7e8a1a902949d148f92550a78"
    sha256 cellar: :any_skip_relocation, big_sur:        "86abcf89c3cf93513d2c1fee31a03cb8ccfdda19ec391ed87b31b2ff0736aa6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2bd9ad3069d68aaaae3db168b9ea3e97f88ceb929404079b94bbf5cdfd4cd0a"
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
