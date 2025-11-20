class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli/archive/refs/tags/0.18.0.tar.gz"
  sha256 "8f2dd7e2f270532f288b7e5db6e90870954986038d51fc4471a24ddd28d445f2"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ac3c58b8c3bd59ff708ba5cf9f62d9283d713447f664629ca9a00fcc89ef8c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ac3c58b8c3bd59ff708ba5cf9f62d9283d713447f664629ca9a00fcc89ef8c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ac3c58b8c3bd59ff708ba5cf9f62d9283d713447f664629ca9a00fcc89ef8c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "84e390baf84cde326d04c7e1d39e62dfeedf89213e426db4b37f36d26b777a80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e9cb1ee7ec968df0a94fdb707767c0916a830e95b2c5f77b085a5809bd16a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2e427f5a57e1679b41c94a2623f452ff1fb002b284e1d1e678f04561c84b6e9"
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

      assert_match "dockerfile", shell_output("#{bin}/faas-cli template pull 2>&1")
      assert_match "node20", shell_output("#{bin}/faas-cli new --list")

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
