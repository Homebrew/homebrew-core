class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cmctl/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "b4c6c88c798f9e8b8b06c6fbeb64fc11eb946b08828a994a44b7e630ffbdaa7b"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cmctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d55363e9112d7eb0669d0afd9bebaed6aaa4531e332201f8fff5bf007bd21e71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e399616de9badc5575d22baaf20d5c5452c1a3427ba0e5526b6265907e3e58cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea9f09d98bf6dd0d66609a131b1011266ba2d24c23124d311ef51482502b111b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2408e81e4faafa8b520ae42a11df5fb348b1bdd539819f269ab7d166e6e36d2a"
    sha256 cellar: :any_skip_relocation, ventura:       "2a462c18fc1abe0da3d2095387eb10bf42aafddda80d80c4a1a19bdde52eb8bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61a962f1faf16288d67bdb0c09ae8597bc813a020537cdd1f6c6d3cdd1003006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ca89dccfcce132bdbe4d4ddf38f76bc1175e9c9897e4bcd43abd5abb1ae3a18"
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
