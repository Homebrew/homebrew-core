class Ingress2gateway < Formula
  desc "Convert Kubernetes Ingress resources to Kubernetes Gateway API resources"
  homepage "https://github.com/kubernetes-sigs/ingress2gateway"
  url "https://github.com/kubernetes-sigs/ingress2gateway/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "a3c74ca555df43e40b0acd89743cb0ade9b1ad72bcd61fad0d0bec0b233a9c7c"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/ingress2gateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62f589debe662edb6b0334b2cc906de5b81168444ab688d77b25cc09a0396a73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62f589debe662edb6b0334b2cc906de5b81168444ab688d77b25cc09a0396a73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62f589debe662edb6b0334b2cc906de5b81168444ab688d77b25cc09a0396a73"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed1c1eb32daca7a1a017ccd4b83442dba6eed99ab9d6177be7779de5243d9ea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65cfc1a5c64753665a15b70d36ed8ba94a666690599d6de0314a9737e2e38056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "363ac48d982fe5071d25fbdaaef9f4c3e42481356fd6d01e97951ec60de94b57"
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
