class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "http://docs.get-faas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      :tag => "0.6.2",
      :revision => "a81705b7f50e89bad580f9930436dbf34996cbec"

  bottle do
    cellar :any_skip_relocation
    sha256 "0841807c7933728e91884f90adeb0ea1714c103c051fa2cdc75d91d4ce1b7837" => :high_sierra
    sha256 "ce466cf52ab108f22a5054d919c3f271d5d825ffaddb6c5e0fa909b4c4e3d0de" => :sierra
    sha256 "4abc9008a61d1cfbd33d6e60cf0ffee6f2d6094c388ef1bac08d749e9159e1e9" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/openfaas/faas-cli").install buildpath.children
    cd "src/github.com/openfaas/faas-cli" do
      project = "github.com/openfaas/faas-cli"
      commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
      system "go", "build", "-ldflags",
             "-s -w -X #{project}/version.GitCommit=#{commit}", "-a",
             "-installsuffix", "cgo", "-o", bin/"faas-cli"
      bin.install_symlink "faas-cli" => "faas"
      pkgshare.install "template"
      prefix.install_metafiles
    end
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
        name: faas
        gateway: http://localhost:#{port}
        network: "func_functions"

      functions:
        dummy_function:
          lang: python
          handler: ./dummy_function
          image: dummy_image
    EOS

    expected = <<~EOS
      Deploying: dummy_function.
      Function dummy_function already exists, attempting rolling-update.

      Deployed. 200 OK.
      URL: http://localhost:#{port}/function/dummy_function
    EOS

    begin
      cp_r pkgshare/"template", testpath

      output = shell_output("#{bin}/faas-cli deploy -yaml test.yml")
      assert_equal expected, output.chomp

      rm_rf "template"

      output = shell_output("#{bin}/faas-cli deploy -yaml test.yml 2>&1", 1)
      assert_match "Stat ./template/python/template.yml", output

      assert_match "ruby", shell_output("#{bin}/faas-cli template pull 2>&1")
      assert_match "node", shell_output("#{bin}/faas-cli new --list")

      output = shell_output("#{bin}/faas-cli deploy -yaml test.yml")
      assert_equal expected, output.chomp

      stable_resource = stable.instance_variable_get(:@resource)
      commit = stable_resource.instance_variable_get(:@specs)[:revision]
      assert_match commit, shell_output("#{bin}/faas-cli version")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
