class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cmctl/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "88a577e2e7007e9df1a5f86817e848339a66b4ae54e6e9ce1c8224038cadeb68"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cmctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4abcaf188931b0fa8665ff34b3d55dcad1bf0529af0b6cb18a6a4ea3e215c322"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "520c67d651d188840f25a8cd50699dac492db8a2031ab753b3fc7374f2dfbcd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3951b26b70dc6dd4ea7c2c6b71ae5abc7c1d4e47aaac2cf7191ebbd21db1803c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8409f3497bed93979f6ff61b1dfa5625e07390ee8badd5aa302b7627ad0c179f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fabef25afa1eaf0ae7fb73d5499685c1dc84ea1de2ebe4b4f7327b18187126e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44e20819dc3337c7e67f1ff1f87e7735386fafaea3523016dd5f5b349c634e4e"
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

    generate_completions_from_executable(bin/"cmctl", "completion")
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
