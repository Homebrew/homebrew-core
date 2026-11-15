class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https://open-policy-agent.github.io/gatekeeper/"
  url "https://github.com/open-policy-agent/gatekeeper/archive/refs/tags/v3.23.1.tar.gz"
  sha256 "8d49585365c26e809754850b4119b0f97eaba608071b1c99bc3e68b41038272e"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/gatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df0936763fbfabc3f3cf24242ee63a71937e04075b0f6a5276aeb30b1f42201b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "423be7687b4db3cca8c9ae5042c069b417c9f1aabae49922758655e66f6edffb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5d9b2d6dcc1e159c7a801f300eca892be33861c1e2d334be706a34dac4d13a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "29a19ec57db72a315f9cc072cf79e5ec76823b12b01f708699500c5be4c5ca9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b9d97e5edd417bae826f948f7b2231b35b54f55eb1248ea923d9e11caafa2a40"
    sha256 cellar: :any,                 x86_64_linux:      "537561379ebb1ff867c4326d4bb4c46d81729dfe5cd3200fbc46a157918aba72"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/open-policy-agent/gatekeeper/v3/pkg/version.Version=#{version}]
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
