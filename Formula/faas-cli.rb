class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.13.11",
      revision: "77ad215bcc6291dbf72c73caffe4d76aa2bb6fb1"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f82a393e3668cff747380822a31fd7e903337bc2f4b236387d4df06f705743c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "cfec77b834eb2d1c0733c8ecc9e69ded746d7e82d92e0c7fbcdf965fc0284a14"
    sha256 cellar: :any_skip_relocation, catalina:      "a68255c417425234cb27cbaa48a02678faec3582102ef6a072de5a31d1c6c02e"
    sha256 cellar: :any_skip_relocation, mojave:        "e444f1863b5b1fda7f74c9632a7ec0ddfe38ecea46841237f4375d652699e2b5"
  end

  depends_on "go" => :build

  def install
    os = "darwin"
    on_linux do
      os = "linux"
    end
    ENV["XC_OS"] = os
    ENV["XC_ARCH"] = "amd64"
    project = "github.com/openfaas/faas-cli"
    ldflags = %W[
      -s -w
      -X #{project}/version.GitCommit=#{Utils.git_head}
      -X #{project}/version.Version=#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), "-a", "-installsuffix", "cgo", "-o", bin/"faas-cli"
    bin.install_symlink "faas-cli" => "faas"
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
