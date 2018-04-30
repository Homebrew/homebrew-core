class Kubeless < Formula
  desc "Kubernetes Native Serverless Framework"
  homepage "https://github.com/kubeless/kubeless"
  url "https://github.com/kubeless/kubeless/archive/v1.0.0-alpha.1.tar.gz"
  sha256 "2ba1e3f43312d47ce712a41ba38a9729074037c2c3030540e88b66fdd321205e"

  bottle do
    cellar :any_skip_relocation
    sha256 "89395ebdecb547c5d843c1d362eabaafc444597b9cc823a8dd1ff20d3624e3e4" => :high_sierra
    sha256 "c3fba20b187a88375e728ef8bf10a026b5d2d92f2ed9fb2fbe561c3c3ce79565" => :sierra
    sha256 "851036f698bd94bd96f28442b4e2d1eb9ddd6fcefa420239cbdea4dac7a18b54" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :recommended

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kubeless/kubeless").install buildpath.children
    cd "src/github.com/kubeless/kubeless" do
      ldflags = %W[
        -w -X github.com/kubeless/kubeless/pkg/version.Version=v#{version}
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
        request = socket.gets
        request_path = request.split(" ")[1]
        if request_path == "/api/v1/namespaces/kubeless/configmaps/kubeless-config"
          response = '{
            "kind": "ConfigMap",
            "apiVersion": "v1",
            "metadata": { "name": "kubeless-config", "namespace": "kubeless" },
            "data": {
              "runtime-images": "[{' \
                '\"ID\": \"python\",' \
                '\"versions\": [{' \
                  '\"name\": \"python27\",' \
                  '\"version\": \"2.7\",' \
                  '\"httpImage\": \"kubeless/python\"' \
                  "}]" \
                '}]"
              }
            }'
        elsif request_path == "/apis/kubeless.io/v1beta1/namespaces/default/functions"
          response = '{
            "apiVersion": "kubeless.io/v1beta1",
            "kind": "Function",
            "metadata": { "name": "get-python", "namespace": "default" }
            }'
        elsif request_path == "/apis/apiextensions.k8s.io/v1beta1/customresourcedefinitions/functions.kubeless.io"
          response = '{
            "apiVersion": "apiextensions.k8s.io/v1beta1",
            "kind": "CustomResourceDefinition",
            "metadata": { "name": "functions.kubeless.io" }
            }'
        else
          response = "OK"
        end
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
