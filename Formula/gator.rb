class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https://open-policy-agent.github.io/gatekeeper/website/docs/gator"
  url "https://github.com/open-policy-agent/gatekeeper/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "085e6ece06fe122f7c9df3b750fe0d3ef9c8c9f3a182460a0b59fbe8b14fdde0"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/gatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54d22304deb041f3b3f3841b8ffd76cfae6034e0cede64c698016d175f038181"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39a3c87cc44ba2d019177bef3fb47194eb06040e712823b63165363bf64466ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39a3c87cc44ba2d019177bef3fb47194eb06040e712823b63165363bf64466ae"
    sha256 cellar: :any_skip_relocation, ventura:        "17f775056d58ceb3301c3009688eab629ec100b6d0a468e53f83f41f1e9436a7"
    sha256 cellar: :any_skip_relocation, monterey:       "d601ac580a7e56cfa747b8b25c0132c26edea462b5d543e3983e1509bc0ca5a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d601ac580a7e56cfa747b8b25c0132c26edea462b5d543e3983e1509bc0ca5a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f36882b3106607196ac528a2c8305cbcb08e4eefa36e98b779ad8ff203988c0d"
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
