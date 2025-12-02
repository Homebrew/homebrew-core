class Ingress2gateway < Formula
  desc "Convert Kubernetes Ingress resources to Kubernetes Gateway API resources"
  homepage "https://github.com/kubernetes-sigs/ingress2gateway"
  url "https://github.com/kubernetes-sigs/ingress2gateway/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "7c511e4c309b62d01ce2128643922637f0ca77524bab2c4c6811bebbb43ff119"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/ingress2gateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a9fc448e0894b03fd683ea68688b23f0e2488393e648c887f5fd1fdeb4be956"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "804894e94d5995db30d5c70e8ae93fadb64d95488792ad588f01508178f7c6ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fe29eb341d887273844fbbb2ac25d7016ea1c035200bcad34cef8ac3e27a905"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6eef8e59f45e555634acea8f44f91845d3e52c57a807aeeabf5ec4f114c3b75b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b532ae021e34552d352eed71e599c80dae9d6037dba5153b433ce30d0b2b73d8"
    sha256 cellar: :any_skip_relocation, ventura:       "c23960ce300c4aa2ea510e24e7c480eb510cc2dfc9365109f0a2d6c7f130b1a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c26492ccbce780760a7ddf26595463229e745b7cba5d453d48fa71692842e909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a76215216004e804caad4063551e07f7ccba6cf55f44d7e5f97cbc6678f34ef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ingress2gateway", "completion")
  end

  test do
    test_file = testpath/"test.yml"
    test_file.write <<~YAML
      apiVersion: networking.k8s.io/v1
      kind: Ingress
      metadata:
        name: foo
        namespace: bar
        annotations:
          nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
          nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
          nginx.ingress.kubernetes.io/ssl-passthrough: "true"
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
        tls:
        - hosts:
          - foo,bar
          secretName: foo-bar-cert
    YAML

    expected = <<~YAML
      apiVersion: gateway.networking.k8s.io/v1
      kind: Gateway
      metadata:
        annotations:
          gateway.networking.k8s.io/generator: ingress2gateway-#{version}
        creationTimestamp: null
        name: nginx
        namespace: bar
      spec:
        gatewayClassName: nginx
        listeners:
        - hostname: foo.bar
          name: foo-bar-http
          port: 80
          protocol: HTTP
        - hostname: foo.bar
          name: foo-bar-https
          port: 443
          protocol: HTTPS
          tls:
            certificateRefs:
            - group: null
              kind: null
              name: foo-bar-cert
      status: {}
      ---
      apiVersion: gateway.networking.k8s.io/v1
      kind: HTTPRoute
      metadata:
        annotations:
          gateway.networking.k8s.io/generator: ingress2gateway-#{version}
        creationTimestamp: null
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

    result = shell_output("#{bin}/ingress2gateway\
                          print\
                          --providers ingress-nginx\
                          --input-file #{testpath}/test.yml\
                          -A")

    assert_equal expected.chomp, result.chomp
  end
end
