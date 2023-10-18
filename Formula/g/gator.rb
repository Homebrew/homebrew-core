class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https://open-policy-agent.github.io/gatekeeper/website/docs/gator"
  url "https://github.com/open-policy-agent/gatekeeper/archive/refs/tags/v3.13.3.tar.gz"
  sha256 "db40b5cccaab5d8ac91716bf54e7a505928a04ecf2deb1946cd9b9975c02fa54"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/gatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a369536a84d08472675977d79b1b197ca5befb4dfc33f81ed94916620b2f7911"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "662ea2e0f60d7c3ddbf6a6c064ca30040dfa5c212db01ea831ef221f7a13f65f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fab4e6f9c07662a317a45082f823103f1ed98e10cba456b6863c3dd1a04de3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd5315f482b35e3d81c31a056d9ec923de4ac1efec450e4592f04fa90353b8a9"
    sha256 cellar: :any_skip_relocation, ventura:        "596ca973adcdaa3afbfc637b289d9a3ac30895527f12d6f86d5aba9439bfd8c0"
    sha256 cellar: :any_skip_relocation, monterey:       "e4f198c677729d23188bcd18decd196a31ac7cabb9927da31e63eb44d8120f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2642114ed618195285e3357231e03a89fcdc7c34301d1dee42cb6f9778bfa16"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/gatekeeper/v3/pkg/version.Version=#{version}
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
    # Create a test constraint template
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

    assert_match version.to_s, shell_output("#{bin}/gator --version")
  end
end
