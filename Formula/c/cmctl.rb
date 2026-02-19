class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cmctl/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "3de4456c6f36a143992661f7357a2bd111b224a72ce7b61d83bfdb3679f36a96"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cmctl.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d261e97e575479d5b88fc0d138a497be6aa7815e5b7d566e0e2a11fc48deba1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0a72773524df6677d6bdc0531ca49d8a1a8774811bc243fcf68a0cfa165a29d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96f6032892618ddaa22a270e58a6dfdb8577547c45b00831990cb5d98f0b2913"
    sha256 cellar: :any_skip_relocation, sonoma:        "736e1fcbaefcfc1e055ee72f6ac1dec0ed2e971c644f0a10c4172ea79061bfba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6a14005f4a18617f2dc2f631eeedae85b11a9b3a9cb48962940c895919b3fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d65c0f7dcc02e285e82c0bb3bbe2e327dc4303cde2d9c656bc7f4f5e9924e1f1"
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
