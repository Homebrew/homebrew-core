class Ingress2gateway < Formula
  desc "Convert Kubernetes Ingress resources to Kubernetes Gateway API resources"
  homepage "https://github.com/kubernetes-sigs/ingress2gateway"
  url "https://github.com/kubernetes-sigs/ingress2gateway/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "c77182394f38e39bb1c14a2e057d6d679e00ac0cec7ab314b6cb7ae9827c9315"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/ingress2gateway.git", branch: "main"

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
