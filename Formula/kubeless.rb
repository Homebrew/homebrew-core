class Kubeless < Formula
  desc "Kubernetes Native Serverless Framework"
  homepage "https://kubeless.io"
  url "https://github.com/kubeless/kubeless/archive/v1.0.8.tar.gz"
  sha256 "c25dd4908747ac9e2b1f815dfca3e1f5d582378ea5a05c959f96221cafd3e4cf"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f0bed8b5c424de1bc1552ba8a4063ab9f68213dd32114166388624958fe69f6" => :big_sur
    sha256 "94927a41f4778a3e99934154bda7db05c4048e83d49a840ecf7eca6ddfbc32e4" => :catalina
    sha256 "0b0f24835a3fb21b5a5459a030f821f2c13691ad8978a02067dfb38f15d8ac6f" => :mojave
    sha256 "ec427f71d144c616cfc1803da51caf69f6ead7cefd5ade2f8c23129d73eec705" => :high_sierra
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
    port = free_port
    server = TCPServer.new("127.0.0.1", port)

    pid = fork do
      loop do
        socket = server.accept
        request = socket.gets
        request_path = request.split[1]
        response = case request_path
        when "/api/v1/namespaces/kubeless/configmaps/kubeless-config"
          '{
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
        when "/apis/kubeless.io/v1beta1/namespaces/default/functions"
          '{
            "apiVersion": "kubeless.io/v1beta1",
            "kind": "Function",
            "metadata": { "name": "get-python", "namespace": "default" }
            }'
        when "/apis/apiextensions.k8s.io/v1beta1/customresourcedefinitions/functions.kubeless.io"
          '{
            "apiVersion": "apiextensions.k8s.io/v1beta1",
            "kind": "CustomResourceDefinition",
            "metadata": { "name": "functions.kubeless.io" }
            }'
        else
          "OK"
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
