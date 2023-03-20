class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager.git",
      tag:      "v1.11.0",
      revision: "2a0ef53b06e183356d922cd58af2510d8885bef5"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efcc73d8f853e47a2b2aff3f09dfdb81cafb6451bce39493548ec2df065c1746"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7551712bd1a48570416813c1c6dfc4b82100821e2b81d31f6ca56f267155deb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06aa57c8c9e3d7315b92b5c0e864325c0cade301dc991a83004604300027e61c"
    sha256 cellar: :any_skip_relocation, ventura:        "1a9eedc1f0cd853fba676d8fe0ef8a446fe136f60b146b4237006622193e2962"
    sha256 cellar: :any_skip_relocation, monterey:       "0d6ef690653ce491d49ad35c309c22e8039a945f2e0150936e102abdf5e281ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "85bebddd52ac6d3e60a77e52868b7d38ebb6312a02cef8b4386d2a0f7de904ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb62a09e8783f73f20daf7dd054baab9b52e5cc7735f3e937b7b0cfa38388c9a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build.name=cmctl
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build/commands.registerCompletion=true
      -X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v#{version}
      -X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctl"
    generate_completions_from_executable(bin/"cmctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmctl version --client")
    # The binary name ("cmctl") is templated into the help text at build time, so we verify that it is
    assert_match "cmctl", shell_output("#{bin}/cmctl help")
    # We can't make a Kuberntes cluster in test, so we check that when we use a remote command
    # we find the error about connecting
    assert_match "connect: connection refused", shell_output("#{bin}/cmctl check api 2>&1", 1)
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
