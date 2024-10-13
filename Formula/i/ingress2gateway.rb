class Ingress2gateway < Formula
  desc "Convert Kubernetes Ingress resources to Kubernetes Gateway API resources"
  homepage "https://github.com/kubernetes-sigs/ingress2gateway"
  url "https://github.com/kubernetes-sigs/ingress2gateway/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "87813319e61b317f9c15e6df9db972a314518570c0b5fef5097c58fdba841a9d"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/ingress2gateway.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "af8bbcd1d0ae9124297ad6ffd754f3e409bff17d55ca7c846ce6c7fe61bc8a4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a489fa8c94579d7efbc7627e15311f52d13ae194911fdef45599e2a0ceb8c968"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d20c2c56a8a896116278ae0d7f149d6a7b83c2e9ba2353c8a661d0fe8b244f76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e87d2f0c51cc39169b3904b6056df027e8e29c894f0a1e2b83f52dc4909ed7b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7414be1c00ccac9b96a3987ca25a6dc03234ecc0fda18e2f3ba9dc469b6be881"
    sha256 cellar: :any_skip_relocation, ventura:        "d823fbdbeec96fd4da4c1a511a1e1b02adb1d1ff24d09fde5c9aa21c2c687969"
    sha256 cellar: :any_skip_relocation, monterey:       "f7b496925d189bbcdd14c698d12154abffe893591ba975f6e4cef87fc312271c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "802c3e0ceb95f43c1cc4815728cfab1d826e5304209ff2676f9f91f02a4d50e5"
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
                          --input-file #{testpath}/test.yml\
                          -A")

    assert_equal expected.chomp, result.chomp
  end
end
