class Ingress2gateway < Formula
  desc "Convert Kubernetes Ingress resources to Kubernetes Gateway API resources"
  homepage "https://github.com/kubernetes-sigs/ingress2gateway"
  url "https://github.com/kubernetes-sigs/ingress2gateway/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "c77182394f38e39bb1c14a2e057d6d679e00ac0cec7ab314b6cb7ae9827c9315"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/ingress2gateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cd6eedc90347967f37c2be2d5a472f2d59cb1ca4544fb845c82b8024aed5c48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c37c69b9716141fe19a22b3e659533be4d6c09d161c2255b0c7eaa1e68563323"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7d6297b75fa0c3aebe810ab8723179d24dd37da3bb65a982dbe3849d49a1c6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b642d9684846de5bdac2011b773a11841438c8a59861b85631e0897f1f29ea92"
    sha256 cellar: :any_skip_relocation, ventura:        "4619cd67314f0584cd5abcd42fbd0625ef5ed747a923eebed0c5320f13a174f6"
    sha256 cellar: :any_skip_relocation, monterey:       "078352ac874427d894344820ac68d059798e018b386cb2014d3fa6766de29e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b11b0d725a6fad9bec4a62bf97ab9ce2121563648adac0fa16d7d4818f9c0719"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ingress2gateway", "completion")
  end

  test do
    test_file = testpath/"test.yml"
    test_file.write <<~EOS
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
    EOS

    expected = <<~EOS
      apiVersion: gateway.networking.k8s.io/v1
      kind: Gateway
      metadata:
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
    EOS

    result = shell_output("#{bin}/ingress2gateway\
                          print\
                          --providers ingress-nginx\
                          --input_file #{testpath}/test.yml\
                          -A")

    assert_equal expected.chomp, result.chomp
  end
end
