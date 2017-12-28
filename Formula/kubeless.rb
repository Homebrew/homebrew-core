class Kubeless < Formula
  desc "Kubernetes Native Serverless Framework"
  homepage "https://github.com/kubeless/kubeless"
  url "https://github.com/kubeless/kubeless.git",
      :tag => "v0.3.2",
      :revision => "fef344fc1f9f0233bb6585953f802bfe906e51cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "903bf1cd82af7d144b17e749a5760e6a5545cf9784d3f54285ec5356d41472f4" => :high_sierra
    sha256 "d95dbf5081d8f2777d16415ed3ec5f69499c671327038b9817a28ab30762ff77" => :sierra
    sha256 "71d9203c8e7056817a4ceb59462665c463522245cf4cfbe453d0f311d8de59f6" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :recommended

  def install
    commit = Utils.popen_read("git rev-parse --short HEAD").chomp
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kubeless/kubeless").install buildpath.children
    cd "src/github.com/kubeless/kubeless" do
      ldflags = %W[
        -w -X github.com/kubeless/kubeless/version.VERSION=v#{version}
        -X github.com/kubeless/kubeless/version.GITCOMMIT=#{commit}
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
