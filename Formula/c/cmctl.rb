class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "572801b99ddab89e1fba09d8142c8ba9bb681d2ee1464e57f959ccbb4562d7d5"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e44ea33a5ae4340ab341480e9ffb3743f11233eb91bcfa149bd9d31960e5066"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60a2604567f74108b54e942415f2b14a4111dbdedf6a65f0801992d5aba3d431"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67b42d4255b0ff3ec1a6c963ec27dd6b1f0441d546c6f478e50be76b5349efd2"
    sha256 cellar: :any_skip_relocation, ventura:        "44fe4dff981fb8c133304997e9858a920d7244f7b45045c986b7ddafcf09cd82"
    sha256 cellar: :any_skip_relocation, monterey:       "98aca5c608ec61c2ead5926256c7905ac736f50d3c1acf51fe9fac4eca9e16b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cc2a837ccdd6fa60fb97575bd91b079936ce4b7b88995ffd11abebbb195d6fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c641cc4112a8c5fc16d9f95cc87cd145261fa82c7d1a279b81ea238e02e93935"
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
