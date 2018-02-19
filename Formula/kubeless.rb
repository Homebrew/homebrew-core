class Kubeless < Formula
  desc "Kubernetes Native Serverless Framework"
  homepage "https://github.com/kubeless/kubeless"
  url "https://github.com/kubeless/kubeless.git",
      :tag => "v0.4.0",
      :revision => "4f4f531f6a1b685bf3842b26cfff5ca7eee533cc"

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

    (testpath/"kubeless-config.yaml").write <<~EOS
      apiVersion: v1
      data:
        deployment: '{}'
        ingress-enabled: "false"
        runtime-images: |-
          [
            {
              "ID": "python",
              "versions": [
                {
                  "name": "python27",
                  "version": "2.7",
                  "httpImage": "kubeless/python@sha256:0f3b64b654df5326198e481cd26e73ecccd905aae60810fc9baea4dcbb61f697",
                  "pubsubImage": "kubeless/python-event-consumer@sha256:1aeb6cef151222201abed6406694081db26fa2235d7ac128113dcebd8d73a6cb",
                  "initImage": "tuna/python-pillow:2.7.11-alpine"
                },
                {
                  "name": "python34",
                  "version": "3.4",
                  "httpImage": "kubeless/python@sha256:e502078dc9580bb73f823504a6765dfc98f000979445cdf071900350b938c292",
                  "pubsubImage": "kubeless/python-event-consumer@sha256:d963e4cd58229d662188d618cd87503b3c749b126b359ce724a19a375e4b3040",
                  "initImage": "python:3.4"
                },
                {
                  "name": "python36",
                  "version": "3.6",
                  "httpImage": "kubeless/python@sha256:6300c2513ca51653ae698a31eacf6b2b8a16d2737dd3e244a8c9c11f6408fd35",
                  "pubsubImage": "kubeless/python-event-consumer@sha256:0a2f9162de56b7966b02b70a5a0bcff03badfd9d87b8ae3d13e5381abd00220f",
                  "initImage": "python:3.6"
                }
              ],
              "depName": "requirements.txt",
              "fileNameSuffix": ".py"
            },
            {
              "ID": "nodejs",
              "versions": [
                {
                  "name": "node6",
                  "version": "6",
                  "httpImage": "kubeless/nodejs@sha256:2b25d7380d6ed06ad817f4ee1e177340a282788596b34464173bb8a967d83c02",
                  "pubsubImage": "kubeless/nodejs-event-consumer@sha256:1861c32d6a46b2fdfc3e3996daf690ff2c3d5ca19a605abd2af503011d68e221",
                  "initImage": "node:6.10"
                },
                {
                  "name": "node8",
                  "version": "8",
                  "httpImage": "kubeless/nodejs@sha256:f1426efe274ea8480d95270c98f6007ac64645e36291dbfa36d759b5c8b7b733",
                  "pubsubImage": "kubeless/nodejs-event-consumer@sha256:b301b02e463b586d9a32d5c1cb5a68c2a11e4fba9514e28d900fc50a78759af9",
                  "initImage": "node:8"
                }
              ],
              "depName": "package.json",
              "fileNameSuffix": ".js"
            },
            {
              "ID": "ruby",
              "versions": [
                {
                  "name": "ruby24",
                  "version": "2.4",
                  "httpImage": "kubeless/ruby@sha256:738e4cdeb5f5feece236bbf4e46902024e4b9fc16db4f3791404fa27e8b0db15",
                  "pubsubImage": "kubeless/ruby-event-consumer@sha256:f9f50be51d93a98ae30689d87b067c181905a8757d339fb0fa9a81c6268c4eea",
                  "initImage": "bitnami/ruby:2.4"
                }
              ],
              "depName": "Gemfile",
              "fileNameSuffix": ".rb"
            },
            {
              "ID": "dotnetcore",
              "versions": [
                {
                  "name": "dotnetcore2",
                  "version": "2.0",
                  "httpImage": "allantargino/kubeless-dotnetcore@sha256:d321dc4b2c420988d98cdaa22c733743e423f57d1153c89c2b99ff0d944e8a63",
                  "pubsubImage": "kubeless/ruby-event-consumer@sha256:f9f50be51d93a98ae30689d87b067c181905a8757d339fb0fa9a81c6268c4eea",
                  "initImage": "microsoft/aspnetcore-build:2.0"
                }
              ],
              "depName": "requirements.xml",
              "fileNameSuffix": ".cs"
            }
          ]
        service-type: ClusterIP
      kind: ConfigMap
      metadata:
        name: kubeless-config
        namespace: kubeless
    EOS

    (testpath/"test.py").write "function_code"

    begin
      ENV["KUBECONFIG"] = testpath/"kube-config"
      system Formula["kubernetes-cli"].opt_bin/"kubectl", "create", "ns", "kubeless"
      system Formula["kubernetes-cli"].opt_bin/"kubectl", "create", "-f", "kubeless-config.yaml"
      system bin/"kubeless", "function", "deploy", "--from-file", "test.py",
                             "--runtime", "python2.7", "--handler", "test.foo",
                             "test"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
