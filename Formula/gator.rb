class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https://open-policy-agent.github.io/gatekeeper/website/docs/gator"
  url "https://github.com/open-policy-agent/gatekeeper/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "af77ac7eedbe429e2b7df2f8470bc98d0af41a99f0829d95fc7883d34e23ba4d"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/gatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ef490b51392c801bd233c948203f292f3492051b612b94e1bf3fb08d20b26b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfabcc4e79037aa8f612e451591278d228890a224de1039784a21428403bdc11"
    sha256 cellar: :any_skip_relocation, monterey:       "2b62f4add0ef218d9de1ca0e2f44e9084b7639760bb3b961ac89dd543ed76156"
    sha256 cellar: :any_skip_relocation, big_sur:        "1324d3b313ebb5270db7a03935687d7c7dd3fd8fee2098bc8b6558c1b3da50b9"
    sha256 cellar: :any_skip_relocation, catalina:       "91c41fa5f027c12cf7cdfd7e5d93eac3b02191f8f07b8f79fc596bbe71dd18d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fc5249c48af682abae97eb41398378fd1ff8acf07be506d4d75a24c648cc00f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/gatekeeper/pkg/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gator"

    generate_completions_from_executable(bin/"gator", "completion")
  end

  test do
    assert_match "gator is a suite of authorship tools for Gatekeeper", shell_output("#{bin}/gator -h")

    # Create a test manifest file
    (testpath/"gator-manifest.yaml").write <<~EOS
      apiVersion: networking.k8s.io/v1
      kind: Ingress
      metadata:
        name: ingress-demo-disallowed
        annotations:
          kubernetes.io/ingress.allow-http: "false"
      spec:
        tls: [{}]
        rules:
          - host: example-host.example.com
            http:
              paths:
              - pathType: Prefix
                path: "/"
                backend:
                  service:
                    name: nginx
                    port:
                      number: 80
    EOS
    # Create a test constraint tempalte
    (testpath/"template-and-constraints/gator-constraint-template.yaml").write <<~EOS
      apiVersion: templates.gatekeeper.sh/v1
      kind: ConstraintTemplate
      metadata:
        name: k8shttpsonly
        annotations:
          description: >-
            Requires Ingress resources to be HTTPS only.
            Ingress resources must:
            - include a valid TLS configuration
            - include the `kubernetes.io/ingress.allow-http` annotation, set to
              `false`.
            https://kubernetes.io/docs/concepts/services-networking/ingress/#tls
      spec:
        crd:
          spec:
            names:
              kind: K8sHttpsOnly
        targets:
          - target: admission.k8s.gatekeeper.sh
            rego: |
              package k8shttpsonly
              violation[{"msg": msg}] {
                input.review.object.kind == "Ingress"
                re_match("^(extensions|networking.k8s.io)/", input.review.object.apiVersion)
                ingress := input.review.object
                not https_complete(ingress)
                msg := sprintf("Ingress should be https. tls configuration and allow-http=false annotation are required for %v", [ingress.metadata.name])
              }
              https_complete(ingress) = true {
                ingress.spec["tls"]
                count(ingress.spec.tls) > 0
                ingress.metadata.annotations["kubernetes.io/ingress.allow-http"] == "false"
              }
    EOS
    # Create a test constraint file
    (testpath/"template-and-constraints/gator-constraint.yaml").write <<~EOS
      apiVersion: constraints.gatekeeper.sh/v1beta1
      kind: K8sHttpsOnly
      metadata:
        name: ingress-https-only
      spec:
        match:
          kinds:
            - apiGroups: ["extensions", "networking.k8s.io"]
              kinds: ["Ingress"]
    EOS

    assert_empty shell_output("#{bin}/gator test -f gator-manifest.yaml -f template-and-constraints/")
  end
end
