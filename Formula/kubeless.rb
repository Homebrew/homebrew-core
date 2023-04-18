class Kubeless < Formula
  desc "Kubernetes Native Serverless Framework"
  homepage "https://kubeless.io"
  url "https://github.com/vmware-archive/kubeless/archive/v1.0.8.tar.gz"
  sha256 "c25dd4908747ac9e2b1f815dfca3e1f5d582378ea5a05c959f96221cafd3e4cf"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54fa03de2d273898f92c28f8a9c431e39b3994a74a60a2e479bff2f566498d2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e717b886542344e4de306b40c9da357856b3511ff1408e193a47f0467464f89f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "966d792c57a107ea1e3c3f6fa30bb8a3caa92a27f5a774ce7e1f32aafb3da52c"
    sha256 cellar: :any_skip_relocation, ventura:        "098350bac0ab2d88ace4379ce663745761f957c051f00cc829efc8f2eb45934d"
    sha256 cellar: :any_skip_relocation, monterey:       "5fbe83105f5054672a6da645ef3a3f837e21021689ee3ed710c4d75787a48829"
    sha256 cellar: :any_skip_relocation, big_sur:        "41ca62a4f60a0f01c18722a91a5447d7725a457dcfb9ab87af591c1332f203d9"
    sha256 cellar: :any_skip_relocation, catalina:       "1f02d973460f58f6ea3acbd260b8a7725e3eacc5f6fb5354a3f907147f3ac6f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a004f7478633e941862f165e3e1188ebf9a045f94ed34cd4fdf7dcee17c2a039"
  end

  deprecate! date: "2022-03-18", because: :repo_archived

  depends_on "go@1.17" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w -X github.com/vmware-archive/kubeless/pkg/version.Version=v#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), "-trimpath",
           "-o", bin/"kubeless", "./cmd/kubeless"
    prefix.install_metafiles

    generate_completions_from_executable(bin/"kubeless", "completion")
  end

  test do
    port = free_port
    server = TCPServer.new("127.0.0.1", port)

    pid = fork do
      loop do
        socket = server.accept
        request = socket.gets
        request_path = request.split[1]
        runtime_images_data = <<-'EOS'.gsub(/\s+/, "")
        [{
          \"ID\": \"python\",
          \"versions\": [{
            \"name\": \"python27\",
            \"version\": \"2.7\",
            \"httpImage\": \"kubeless/python\"
          }]
        }]
        EOS
        response = case request_path
        when "/api/v1/namespaces/kubeless/configmaps/kubeless-config"
          <<-EOS
          {
            "kind": "ConfigMap",
            "apiVersion": "v1",
            "metadata": { "name": "kubeless-config", "namespace": "kubeless" },
            "data": {
              "runtime-images": "#{runtime_images_data}"
            }
          }
          EOS
        when "/apis/kubeless.io/v1beta1/namespaces/default/functions"
          <<-EOS
          {
            "apiVersion": "kubeless.io/v1beta1",
            "kind": "Function",
            "metadata": { "name": "get-python", "namespace": "default" }
          }
          EOS
        when "/apis/apiextensions.k8s.io/v1beta1/customresourcedefinitions/functions.kubeless.io"
          <<-EOS
          {
            "apiVersion": "apiextensions.k8s.io/v1beta1",
            "kind": "CustomResourceDefinition",
            "metadata": { "name": "functions.kubeless.io" }
          }
          EOS
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
