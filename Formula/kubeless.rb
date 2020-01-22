class Kubeless < Formula
  desc "Kubernetes Native Serverless Framework"
  homepage "https://kubeless.io"
  url "https://github.com/kubeless/kubeless/archive/v1.0.6.tar.gz"
  sha256 "828a04600eb1506e107f23ddd02dad0335c24450ac89fcf8f261c5f5cd0e570a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ed81401f5b4031e28ab1fe472b9d9a2deddc879eef6959234d087ba76c572882" => :catalina
    sha256 "b75024000765c7c616d99e5893c34e3413965a7b26e1c89b49d478d49cf73f3e" => :mojave
    sha256 "762ad7bb6a7ee337f9449591b2efafe9572614286ce3c9d15b47b3fdc30f44eb" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w -X github.com/kubeless/kubeless/pkg/version.Version=v#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), "-trimpath",
           "-o", bin/"kubeless", "./cmd/kubeless"
    prefix.install_metafiles
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
