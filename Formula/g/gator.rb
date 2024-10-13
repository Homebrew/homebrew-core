class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https://open-policy-agent.github.io/gatekeeper/website/docs/gator"
  url "https://github.com/open-policy-agent/gatekeeper/archive/refs/tags/v3.17.1.tar.gz"
  sha256 "0c81dd2326c017dd4e7c61745525ff8b4ce8a467fca10c96df5696cea2009db7"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/gatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "218fe90b680e0b662dc1b431e7f557aa7bfc5c6f73495afd03f5345946bd8fe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "218fe90b680e0b662dc1b431e7f557aa7bfc5c6f73495afd03f5345946bd8fe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "218fe90b680e0b662dc1b431e7f557aa7bfc5c6f73495afd03f5345946bd8fe9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "218fe90b680e0b662dc1b431e7f557aa7bfc5c6f73495afd03f5345946bd8fe9"
    sha256 cellar: :any_skip_relocation, sonoma:         "d14e0ad02a6cbea5ddcfda33378e8ed8d9cd96581bb800d71f926f2b815b379c"
    sha256 cellar: :any_skip_relocation, ventura:        "d14e0ad02a6cbea5ddcfda33378e8ed8d9cd96581bb800d71f926f2b815b379c"
    sha256 cellar: :any_skip_relocation, monterey:       "d14e0ad02a6cbea5ddcfda33378e8ed8d9cd96581bb800d71f926f2b815b379c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "566d9c4a2b469d277c17bdf8e93cfd26493f84c313058115e81227da21be0bb5"
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
