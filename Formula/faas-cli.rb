class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.13.2",
      revision: "eecaee04d59238c4b969b830f39c6f0c30a8868d"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "65b9db3d39329f4595cdcbd405404d922b7c1ce5ce0e9f386e30e32855c4aac4"
    sha256 cellar: :any_skip_relocation, big_sur:       "89e9ce8efca26a75c561134c48d3c74fd9171fca3fa93d3dd58c380e5defaa3a"
    sha256 cellar: :any_skip_relocation, catalina:      "12817b376b182bb12b51731615beb7e39b831d6217bff294dfdf1ab968bb4f8a"
    sha256 cellar: :any_skip_relocation, mojave:        "6ca1c7f2d37ac19befb416ce012b0a1a4830593bed1ed60370bf992a6939f6b7"
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
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
