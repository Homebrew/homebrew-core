class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli/archive/refs/tags/0.17.0.tar.gz"
  sha256 "1199ceaac8657b00ef61699004fdef5230d6f1af5d202db7de1e7ec392ea69af"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43d7d884b9f53a188206a3db6af3502a911cdd2cac19eaff18fb92e652a3ead7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43d7d884b9f53a188206a3db6af3502a911cdd2cac19eaff18fb92e652a3ead7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43d7d884b9f53a188206a3db6af3502a911cdd2cac19eaff18fb92e652a3ead7"
    sha256 cellar: :any_skip_relocation, sonoma:        "160e8fddc915cc0fdce3bfb6682c82894b77a163b76c8e06652c154c7fee1dda"
    sha256 cellar: :any_skip_relocation, ventura:       "160e8fddc915cc0fdce3bfb6682c82894b77a163b76c8e06652c154c7fee1dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe5d5a3b4ebc114eaf479bd577c62046219ba6cb906c66738c509162c0ac610"
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

    (testpath/"test.yml").write <<~YAML
      provider:
        name: openfaas
        gateway: https://localhost:#{port}
        network: "func_functions"

      functions:
        dummy_function:
          lang: python
          handler: ./dummy_function
          image: dummy_image
    YAML

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
