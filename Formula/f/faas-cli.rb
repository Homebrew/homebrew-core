class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli/archive/refs/tags/0.16.29.tar.gz"
  sha256 "f546576083a8787159d276f01c48e869246b370ae1761154543dc1ba241f1ea3"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e178250429dbf8ce373ca080ed8bc452c9b22b73cecc7be44598dbd2d08bdbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "910cc032189a4e9530205be57e1f67d1c7e82a44729a5658fcc6301e878bbef4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d79f5d75e8aca2c6e65e09bc16b45badabd0e97fe6d0f7872b2722b25458f6be"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7321cb4ba493958bc8e5cfb8bdc6f380f6bb14c7a05df906b24f00623a90993"
    sha256 cellar: :any_skip_relocation, ventura:        "3313160bceab37c021360899482bc5ec8de63facefdf5812b1657cfea0089ed5"
    sha256 cellar: :any_skip_relocation, monterey:       "22b26c1ba8bac021cb30d1b49a2a4e1b5be919d2169a6f02fee14bca2b28b378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f889acd0e8c270722f851c152824d9972dbada3da52201e80716321f675df8ab"
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
