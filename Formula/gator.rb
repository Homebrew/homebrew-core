class Gator < Formula
  desc "CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https://open-policy-agent.github.io/gatekeeper/website/docs/gator"
  url "https://github.com/open-policy-agent/gatekeeper/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "cccdd43e1414a32acb6569e79747e66bb296db28a82f48303c878b797c742cb9"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/gatekeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f1f847f0d8fc3e0087583ecbe86541fb04ca2f9d8eef3d6a9c8ccf24be90677"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da0794ab3624824f643fc76c5268e98a073c7004e85310c5fd65caf6f7d31d01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dce7bc4b45efb10074737396e01e7621f68281e599caa4aaf2b355af5dbe20e"
    sha256 cellar: :any_skip_relocation, ventura:        "cfab20e488566d51c7e32ef1e4f0c93de623c5074583135272b75146ac2cdb84"
    sha256 cellar: :any_skip_relocation, monterey:       "abe8e639c2b221fc96adeaeb278d32995f974b895dbb76a20669d020a98237fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "68e67566d353b61de34e7d0ebae2e534f0ee7108563ac1c06d1b91a323ce20da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd8934c4ecc1ef78e2cb100fe2d1f52971bf127355ca7d87d21fef51baaaee63"
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
