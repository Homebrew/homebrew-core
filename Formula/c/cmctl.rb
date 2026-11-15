class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cmctl/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "5dd1bc9a68e0d3a76776746b4c20b60e44516176b97921dd5d8e71c304726182"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cmctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb85f23d67cf27f6bdc08a39bff5a237178259c41b3875d678a0b8fd56297c6e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a881921ec3321d24f748ebf90006bc22890261054f1271891f8e2afb9248fe81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b3ae32507235bd3c48de6e25c9d32efd67a01754d5a8401bf9723021a8192897"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8420e51c988ae22c0fffe39dcee1e993aa66a8f81e6fd05cd6b31134972eda26"
    sha256 cellar: :any,                 x86_64_linux:      "1b9bfcf48c1ae1944d0d5d94c10a804738c04eb096e07ff85920129e426ad097"
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
