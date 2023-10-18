class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.16.17",
      revision: "f72db8de657001a2967582c535fe8351c259c5f6"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4179ca4cec379aa22c9de517d54ee747b1cd985c7363f7942e281c7207f4e8d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c0f3915800f04cf0f3d86eaca3bc86b80b180890da10416392542c390e15dbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05b65d0251d2059ea5bf61c8ba870dfd924b889ab5085105f45a208604745f2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d3187a5e1cc7d3db0b93b068f5b83a3c481ebed868df90969c41a81a3e1d2d0"
    sha256 cellar: :any_skip_relocation, ventura:        "ff1f5f981ae6701ababa089b7df77e2040c1c01004be658453ed174bba9bff7b"
    sha256 cellar: :any_skip_relocation, monterey:       "ffcf5e5f99edb89ed86b5ef75779aa95afb2335170cd575f6661e6a8cb481b56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dea2e960f935c1f3678d5b866514bcb0a51f3633e9f2d52f5e6ab4402d3f2cb9"
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
