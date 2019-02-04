class Kubeless < Formula
  desc "Kubernetes Native Serverless Framework"
  homepage "https://github.com/kubeless/kubeless"
  url "https://github.com/kubeless/kubeless/archive/v1.0.2.tar.gz"
  sha256 "ad74c93f408c8eeac1c17fac82309f38b6e00c739330ffc8c19bd067bb2a2f68"

  bottle do
    cellar :any_skip_relocation
    sha256 "b052a492bf44340f787c6eaad8e521681d72ce0473cdbfc560f2b02c1e8772e3" => :mojave
    sha256 "fa384d8c42c6c716fa60f08ba4ccdf25acc6dfdce219559c7734c62de40663cc" => :high_sierra
    sha256 "afa6c343f7a2c4ee134da1b479d0f47ed2ab2b3a4c8aba83a82b05c7979821e2" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kubeless/kubeless").install buildpath.children
    cd "src/github.com/kubeless/kubeless" do
      ldflags = %W[
        -w -X github.com/kubeless/kubeless/pkg/version.Version=v#{version}
      ]
      system "go", "build", "-o", bin/"kubeless", "-ldflags",
             ldflags.join(" "), "./cmd/kubeless"
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
