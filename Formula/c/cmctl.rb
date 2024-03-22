class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cmctl/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "fbb3f0a65e01a534e0946cbeb48b7ae8f758d48cca21957b15681b2cdfde0ad6"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cmctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "338822f26703c0581823595f44cce36df3cb8ffe9ab253405df586597fd15745"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82835263503333714b65f7f1673627ccb72651e12a232542c87a078ec6c1370f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a29cb9219d4bce61335bc041a975974aea5e3c98c7d2fc180ab994841a6de3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ea753a5707116635660d8f5fa7bdb688d40b36c8ae5c72cc15c8c2e2053e439"
    sha256 cellar: :any_skip_relocation, ventura:        "eaf825d88f25585774cce0db95b86a882309914f38b92d3124a4eca12bbe20cf"
    sha256 cellar: :any_skip_relocation, monterey:       "30663a9b9cfedaafdc278e13d9435cb829eeef08bdbb26f986ba0f02bb70308f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfda7a381070d98daf6d973ddeb57a4f5e51d07936d1ec6966bf6c1b00431a17"
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
    assert_match "error: error finding the scope of the object", shell_output("#{bin}/cmctl check api 2>&1", 129)
    # The convert command *can* be tested locally.
    (testpath/"cert.yaml").write <<~EOF
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
    EOF

    expected_output = <<~EOF
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
    EOF

    assert_equal expected_output, shell_output("#{bin}/cmctl convert -f cert.yaml")
  end
end
