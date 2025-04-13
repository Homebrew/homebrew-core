class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https://open-policy-agent.github.io/gatekeeper/"
  url "https://github.com/open-policy-agent/gatekeeper/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "61394f83adb502936736b0720efd7f3734d2eeea8f467e369ba7632aaedcc45d"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/gatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b14a14eac1e767105da2a07ef072ed237cf6dbdbdca171a6ee0efea5f6dbe7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3648530a6d9d10086cd07f18c01b8dac5d5a3d561a57923c3db65a6f5f25813f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f99cadce227ea48ea7c334a80ded14dac4e739bc5008f36d4e5746f1081549ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bc27b9c6dae2bbd68bcc7d81b501248465a053ded2f8526a5eb5dbed9a6d57d"
    sha256 cellar: :any_skip_relocation, ventura:       "b98a3b99387298fd9757a3194c8155a14bbd98432cefbd8ecfea25492aaa2279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15e65131fa98111ad79b1aef4ae65270c5756fb2d65f5f04c7e05fc40c5b5d97"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/gatekeeper/v3/pkg/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gator"

    generate_completions_from_executable(bin/"gator", "completion")
  end

  test do
    assert_match "gator is a suite of authorship tools for Gatekeeper", shell_output("#{bin}/gator -h")

    # Create a test manifest file
    (testpath/"gator-manifest.yaml").write <<~YAML
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
    YAML
    # Create a test constraint template
    (testpath/"template-and-constraints/gator-constraint-template.yaml").write <<~YAML
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
    YAML
    # Create a test constraint file
    (testpath/"template-and-constraints/gator-constraint.yaml").write <<~YAML
      apiVersion: constraints.gatekeeper.sh/v1beta1
      kind: K8sHttpsOnly
      metadata:
        name: ingress-https-only
      spec:
        match:
          kinds:
            - apiGroups: ["extensions", "networking.k8s.io"]
              kinds: ["Ingress"]
    YAML

    assert_empty shell_output("#{bin}/gator test -f gator-manifest.yaml -f template-and-constraints/")

    assert_match version.to_s, shell_output("#{bin}/gator --version")
  end
end
