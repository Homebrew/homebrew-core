class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https://open-policy-agent.github.io/gatekeeper/"
  url "https://github.com/open-policy-agent/gatekeeper/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "b93d70151801eec39574fff408c1ea592061673123e5cb869a7f97d0056fb30e"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/gatekeeper.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd01173581a0bdc7578d14bd531b65efb84e804a01652d35d8274c638acd102e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf8d46c3f835c40a9c557895a8643c7e4935874c5ce231370dcf122bc6d6ca56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "328c00ede71cef6304cbbdf4ec60eb37c317a0d68269fb0c146b440c812f786a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9c3268f584d90831bb6007fd76ca04dc4b4e2e628bf8ad02e3addfc62d3f4ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4436e79ddf336e381202723c0c9221fe69ff5e11df574e77b5228b6de6e984ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ec2e2065712f7ce6524ef29ef34094923e59cffc0863832ec4edfa424b3c6bf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/gatekeeper/v3/pkg/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gator"

    generate_completions_from_executable(bin/"gator", shell_parameter_format: :cobra)
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
