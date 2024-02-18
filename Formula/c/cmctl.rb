class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "d04eb7add1a2dde3a708c8ab2d897400b8b6adf9898d3b301069561c46046101"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "607f0ec4a9cf6f2e9699083fdc247d45e85a48c93d2ae6dc2207d4734699f6c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adacf66c06b480bc93bd4b176e46feb1042e6345daeb383a15e63231325efd9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9eb2c13eb23f0134326c53d2dca952bf285d84fa51ffa97548d793b21a56631"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e267df7e1e1dad3204140f5b24f57adb036ca26bf9cfaa7a570fce920d6c65b"
    sha256 cellar: :any_skip_relocation, ventura:        "71cd09e4e48758543056f5d8b1b6e8d48e79d96b5206f37486034108d68da9fd"
    sha256 cellar: :any_skip_relocation, monterey:       "242457b9852f728f61fb3c7453e4fe29e0afd1a032be30d207c2c7e44ba59715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd3c803f5689e157431793c156d44d2741960bb2cadcfa30ca4b07a363aae8ad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build.name=cmctl
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build/commands.registerCompletion=true
      -X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v#{version}
      -X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=#{tap.user}
    ]

    cd "cmd/ctl" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

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
