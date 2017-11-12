class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "http://docs.get-faas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      :tag => "0.5.0",
      :revision => "91177ec27037eccaf6e827c265a0e452e772f1ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "828a53dd0be993ced75a820d0b99684499697c0545d7fca9273f3124957b29ee" => :high_sierra
    sha256 "61309e539be5d138ae42f827868c2c5661a73b7c97bc8b829eae470a9e0f5672" => :sierra
    sha256 "482dc21752ebd4aaae2e7646f949c521bb8ac826b41188c3f50b247dba897c75" => :el_capitan
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
      Removing old function.
      Deployed.
      URL: http://localhost:#{port}/function/dummy_function

      200 OK
    EOS

    begin
      cp_r pkgshare/"template", testpath

      output = shell_output("#{bin}/faas-cli deploy -yaml test.yml")
      assert_equal expected, output

      rm_rf "template"

      output = shell_output("#{bin}/faas-cli deploy -yaml test.yml 2>&1", 1)
      assert_match "stat ./template/python/template.yml", output

      assert_match "ruby", shell_output("#{bin}/faas-cli template pull 2>&1")
      assert_match "node", shell_output("#{bin}/faas-cli new --list")

      output = shell_output("#{bin}/faas-cli deploy -yaml test.yml")
      assert_equal expected, output

      stable_resource = stable.instance_variable_get(:@resource)
      commit = stable_resource.instance_variable_get(:@specs)[:revision]
      assert_match commit, shell_output("#{bin}/faas-cli version")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
