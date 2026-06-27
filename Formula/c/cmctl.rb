class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cmctl/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "4e7f137c2b5411f92948749dbdb31d61911088a54d32e14aea609da02c203bb5"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cmctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "271671ba1bdfaa5a69f55f616a89b06e1acc5bdf7f13dc848d6655cf7178b25f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a42ced3630aafc6c83f88f391d41e3000b3ac86504670847e2a7e6b58cffc63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbbf9b497ec577ea8243a5bb4866450f7a4037def0cdf4f898099298d494caa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eb05bd9dabd9c5704431fa5606dd3d1565c3df246cde61441695643de1d00d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0508c06169c85a918120f264e9d9578e0ca802ef0500c634e928f6cfc542a01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd6659b2651cd73fba23df6899578954392f7a77b557cdf00d2dc3d24cafe61a"
  end

  depends_on "go" => :build

  def install
    project = "github.com/cert-manager/cmctl/v2"
    ldflags = %W[
      -s -w
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
