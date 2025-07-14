class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cmctl/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "087b556ab87a9f9d976be4bf72ed5593f080426e7d3cc59ad73130e5bedd0ab5"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cmctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "debfac1b07f3c1c7eeb262887f5210c5114f5465e7dbeb34ffc6c9c817e05a55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b828e8243bf67ab2d609c418e33a68a3536ff29ef2c6ccb57660b7095b1ff1b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "485d5fc7e498e8bf39e1a98362fb3cd6cd30eb4ba5706d0efbcd90d93a2823d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b2c32bef8d8e14d354c229dcabfc4f7ee1d602dda5bc1963f254f421a5ab4f7"
    sha256 cellar: :any_skip_relocation, ventura:       "ecf8e20f865dcca9caebc3064684f900127de414a294d15318a7bc1285a8123e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0010011f34104b4b842af43700519b3bf42400108e75923615d7da890ef098a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbefa5718ace5b54307ea7c5a94049235106980b3b1c16680ab008a6bb91882a"
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
        creationTimestamp: null
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
