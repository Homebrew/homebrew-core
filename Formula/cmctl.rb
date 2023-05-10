class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager.git",
      tag:      "v1.11.2",
      revision: "4767427a40e0e193c976fd6bc228f50de8950572"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39d2595778e72a390dfb63130b7d9947ffefdd67141693d6db30e01fbfe58af4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2cc43ef960204c6fa5243f1aa93b234f09cc3000aaf5586505e0aa914faacdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0a416a2bd5f5093c39626be0227b73bb15a28ad79c9f9f6ba0206e64b8bb859"
    sha256 cellar: :any_skip_relocation, ventura:        "63e964ede32c0952f7d98ef22bdfe40a38d95213c1716b164289f6ddab5e1fa7"
    sha256 cellar: :any_skip_relocation, monterey:       "78805013daf4cb03f07a557baf46a23fa1e4ba175d767689251402e2f640d3ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "c40a2050f76b23da20d70c34c2721dd579ce508554955611d8d88626619d516b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fba711369e6d661ea6bb68b0fb47c749ed2e1e758f5b84ce17810cc7dbf9f8d"
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
