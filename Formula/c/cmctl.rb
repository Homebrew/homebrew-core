class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cmctl/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "83226abe4516e4e39953dee0d341b26e4c6f5a7f2f62ea07074bd2f8dd55c664"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cmctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eadb67d79ee52df9b729545c75dc862f3cafa4998c9cd29c43de168180a37e4f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "886c201764a25ecc7bde87ec9f5af0906774fefc16e49dc6389ce5cbc24f5858"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bfbffbe343313bb19a2d21feacc289bf973c75f8bdf8b7bbeec45bc45264d584"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c756ae42d2799c0c226df646cb1749143d9a70a9ffd74cd73abd61060b62e8dc"
    sha256 cellar: :any,                 x86_64_linux:      "c5dcb068f1a918636d63f031c8a7ba61301a20ea2669001718faf6b89cc9c419"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    project = "github.com/cert-manager/cmctl/v2"
    ldflags = %W[
      -X #{project}/pkg/build.name=cmctl
      -X #{project}/pkg/build/commands.registerCompletion=true
      -X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v#{version}
      -X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cmctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmctl version --client")
    # The binary name ("cmctl") is templated into the help text at build time, so we verify that it is
    assert_match "cmctl", shell_output("#{bin}/cmctl help")
    # We can't make a Kubernetes cluster in test, so we check that when we use a remote command
    # we find the error about connecting
    assert_match "error: error finding the scope of the object", shell_output("#{bin}/cmctl check api 2>&1", 1)
    # The convert command *can* be tested locally.
    (testpath/"cert.yaml").write <<~YAML
      apiVersion: cert-manager.io/v1beta1
      kind: Certificate
      metadata:
        name: test-certificate
      spec:
        secretName: test
        issuerRef:
          name: test-issuer
          kind: Issuer
        commonName: example.com
    YAML

    expected_output = <<~YAML
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        name: test-certificate
      spec:
        commonName: example.com
        issuerRef:
          kind: Issuer
          name: test-issuer
        secretName: test
      status: {}
    YAML

    assert_equal expected_output, shell_output("#{bin}/cmctl convert -f cert.yaml")
  end
end
