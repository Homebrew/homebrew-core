class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli/archive/refs/tags/0.16.34.tar.gz"
  sha256 "3b19c635be5ea76249d85eac0e362271080808716585823d91681904b98d970b"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8234e965101a47564c00ad9b5d90e9ae02bf74540940c45aa4d787edbb051552"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5707ba58d74c4cd5231b88bee90c6bbb728be7f08e718a425e281eea3514d35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90e7106cff20ed0ab1c81f8a8778e358c0f041d57521b16ec7ffad3f3abecad6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c417bab8b1bc59d082f1149a878cf931bdea0f471f48264e19aa669085e7b360"
    sha256 cellar: :any_skip_relocation, ventura:        "d2ef4e17e5f723330162e80f21789a6f177ba6bb47d9d862b1ecee75442cad41"
    sha256 cellar: :any_skip_relocation, monterey:       "267020a604ea344bad40c8794719473db3679b244163cd690065524eaa9efbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bbba2623de5d143f57540648433afe33f98fc7912b3eb40724eb2a2893dd015"
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
