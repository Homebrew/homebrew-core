class Ingress2gateway < Formula
  desc "Convert Kubernetes Ingress resources to Kubernetes Gateway API resources"
  homepage "https://github.com/kubernetes-sigs/ingress2gateway"
  url "https://github.com/kubernetes-sigs/ingress2gateway/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "881f2599b39d29f14c07e1ae12c60ffbbe636ae07a7ca6e1491d70bb8ab37c5f"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/ingress2gateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c666d46833c0a2649f64984d970ceb1b1ee40f7d8edf20306872017b169f7b7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c666d46833c0a2649f64984d970ceb1b1ee40f7d8edf20306872017b169f7b7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c666d46833c0a2649f64984d970ceb1b1ee40f7d8edf20306872017b169f7b7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4649d41cf12024af7467b36081fd7030936b0c73b8f58bb80594eb17c09e54e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5719790e6916160dfc6ad57e3ff613808fbe25609d0431e626f6e29a4268b8f"
    sha256 cellar: :any,                 x86_64_linux:  "a5935e8ded9b3f9ab4c0ad1e6dc804a5ed0ecd25fca384330ff890b9ce07dc29"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubernetes-sigs/ingress2gateway/pkg/i2gw.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ingress2gateway", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.yml").write <<~YAML
      apiVersion: networking.k8s.io/v1
      kind: Ingress
      metadata:
        name: foo
        namespace: bar
        annotations:
          cert-manager.io/cluster-issuer: "letsencrypt-prod"
        labels:
          name: foo
      spec:
        ingressClassName: nginx
        rules:
        - host: foo.bar
          http:
            paths:
            - pathType: Prefix
              path: "/"
              backend:
                service:
                  name: foo-bar
                  port:
                    number: 443
    YAML

    expected = <<~YAML
      apiVersion: gateway.networking.k8s.io/v1
      kind: Gateway
      metadata:
        annotations:
          gateway.networking.k8s.io/generator: ingress2gateway-#{version}
        name: nginx
        namespace: bar
      spec:
        gatewayClassName: nginx
        listeners:
        - hostname: foo.bar
          name: foo-bar-http
          port: 80
          protocol: HTTP
      ---
      apiVersion: gateway.networking.k8s.io/v1
      kind: HTTPRoute
      metadata:
        annotations:
          gateway.networking.k8s.io/generator: ingress2gateway-#{version}
        name: foo-foo-bar
        namespace: bar
      spec:
        hostnames:
        - foo.bar
        parentRefs:
        - name: nginx
        rules:
        - backendRefs:
          - name: foo-bar
            port: 443
          matches:
          - path:
              type: PathPrefix
              value: /
      status:
        parents: []
    YAML

    output = shell_output("#{bin}/ingress2gateway print --providers ingress-nginx --input-file #{testpath}/test.yml")
    assert_equal expected.chomp, output.chomp
  end
end
