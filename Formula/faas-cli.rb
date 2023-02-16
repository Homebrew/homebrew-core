class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.15.9",
      revision: "45c1d906b77709adde47c35bed868026266389e8"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48da3ea58b7cd24befffcbc3a9d3190696344bc6f1dd690185c170bc250b53b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d05e0680ada5447b280c128c1f6cbcbac2a637e46d7e99bdfee71d08d1794bd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf809b2c4a2bfad5690b0ec69539c52fad4b986a3d30b5f64d32fcf3e32e6680"
    sha256 cellar: :any_skip_relocation, ventura:        "b87a20caef1d58278dceb908ab4ac3f0280c84807432dc96bf8c57907c0eeef4"
    sha256 cellar: :any_skip_relocation, monterey:       "7761e29e7240d80e8a876d2a824f2715d899212733a1f18b775b179a0941c4ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "02d388464369be779ee12e2bbbd2a15dbdea13584ebcb91866f20ab761df9683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf5bb6bc46f623e93ed41569d8fba729adf0877c0ba861ec65500128b8daee3d"
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
