class Kubeless < Formula
  desc "Kubernetes Native Serverless Framework"
  homepage "https://github.com/kubeless/kubeless"
  url "https://github.com/kubeless/kubeless.git",
      :tag => "v0.3.4",
      :revision => "d16de3f6fd52460753fb81fafbcfc514dfc702e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c12afb34ddf3afbb246f9a676dfdb9c8fd5bbae1d4e020bedfc51c29f5dde32" => :high_sierra
    sha256 "51cb68a71f9731705a2adada57256983be66f857b7040f9c03cef667756db148" => :sierra
    sha256 "56c2c77642286c95dc1c2cd4418d76ce107fe51dbd1c860ab0ac2868677b5e17" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :recommended

  def install
    commit = Utils.popen_read("git rev-parse --short HEAD").chomp
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kubeless/kubeless").install buildpath.children
    cd "src/github.com/kubeless/kubeless" do
      ldflags = %W[
        -w -X github.com/kubeless/kubeless/cmd/kubeless/version.VERSION=v#{version}
        -X github.com/kubeless/kubeless/cmd/kubeless/version.GITCOMMIT=#{commit}
      ]
      system "go", "build", "-o", bin/"kubeless", "-ldflags", ldflags.join(" "),
             "./cmd/kubeless"
      prefix.install_metafiles
    end
  end

  test do
    require "socket"

    server = TCPServer.new("127.0.0.1", 0)
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

    (testpath/"kube-config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:#{port}
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    (testpath/"test.py").write "function_code"

    begin
      ENV["KUBECONFIG"] = testpath/"kube-config"
      system bin/"kubeless", "function", "deploy", "--from-file", "test.py",
                             "--runtime", "python2.7", "--handler", "test.foo",
                             "test"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
