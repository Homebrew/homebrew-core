class Ingress2gateway < Formula
  desc "Convert Kubernetes Ingress resources to Kubernetes Gateway API resources"
  homepage "https://github.com/kubernetes-sigs/ingress2gateway"
  url "https://github.com/kubernetes-sigs/ingress2gateway/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "741f21ed50470f531d474e35253b8ba5aff6fc13e1ad8ca64049ece5cf1faae1"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/ingress2gateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "201b988b580c4e42c48e08760988334468e3826cb699be2f174e7162b083776c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "201b988b580c4e42c48e08760988334468e3826cb699be2f174e7162b083776c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "201b988b580c4e42c48e08760988334468e3826cb699be2f174e7162b083776c"
    sha256 cellar: :any_skip_relocation, sonoma:        "eae6ceed87bec26779eb52c1198d4dc312f60ffbe0fc1924f1116fa24c3678be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c1b42a27918c80219820e78b83967a75fa852431dc1a3a6be75532c6d9dd232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7054cb26468e37aa3310911a43bda1c8a17ad8c336def48e6094d8bf674f7b67"
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
          name: rule-0
      status:
        parents: []
    YAML

    output = shell_output("#{bin}/ingress2gateway print --providers ingress-nginx --input-file #{testpath}/test.yml")
    assert_equal expected.chomp, output.chomp
  end
end
