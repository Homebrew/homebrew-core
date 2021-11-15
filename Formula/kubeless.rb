class Kubeless < Formula
  desc "Kubernetes Native Serverless Framework"
  homepage "https://kubeless.io"
  url "https://github.com/kubeless/kubeless/archive/v1.0.8.tar.gz"
  sha256 "c25dd4908747ac9e2b1f815dfca3e1f5d582378ea5a05c959f96221cafd3e4cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15311bbda88c203d08df3991e4a6ca8fac3d996073ab5c514f840cc6f0d74dca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "457c1b5b7f10562288c98ec9a5bd75378256a930ebead0f4acd1dd02a157c81a"
    sha256 cellar: :any_skip_relocation, monterey:       "a9d5c5ff0e2f625e2c946f4a170b4654a919177d69550763f80f8fb29bf88277"
    sha256 cellar: :any_skip_relocation, big_sur:        "617d7ec712263ee395d113e427a8557a0b4da5f0a13904aaa7b6dd88076d2e34"
    sha256 cellar: :any_skip_relocation, catalina:       "622d26db25c0c672ab9204caf7478453912916c6d3cf4626818afb1e7e029f56"
    sha256 cellar: :any_skip_relocation, mojave:         "4892e5ecc077136f2259e496b82951e4601fbe4e5fc2b5c5d3cf84216b15f29d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b87b97575b27569433e254396eaa15c265fd9f11de80c916e346e7fb0271559f"
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
