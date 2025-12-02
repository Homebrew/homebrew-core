class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https://open-policy-agent.github.io/gatekeeper/"
  url "https://github.com/open-policy-agent/gatekeeper/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "b93d70151801eec39574fff408c1ea592061673123e5cb869a7f97d0056fb30e"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/gatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b24e0539f519252f6635172cfa3784da34be9607838fbd8c0f37a47c117121d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e2351a4d0d4163f7840df4e7d0fd9463dbb6fcee5559910535d7493406dfdb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85521ed59f263bb188e2efd5f28cf4ad12ade4e810d476c307e25e9f436536af"
    sha256 cellar: :any_skip_relocation, sonoma:        "706da3cd2d1fde49ea2951ef22c710f5432c33c408da2ffde1eccdb6a662f614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "320923754a985e6fd15bdca53c8e34d2cd0312bc771e1ea6f4660df9545bf8ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e24ced059fcc38ccd8f9c4d55486005a43de840a8f945f4f990ff8f9f7d792"
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
