class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager.git",
      tag:      "v1.10.1",
      revision: "a96bae172ddb1fcd4b57f1859ab9d1a9e94f7451"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c88f2ea9a0dcf0f7e24e46ba4506ac0eec424e9c85e37cfd86a349d623fa6be2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8cce9a92d95288546d4199e659e01b1e1ce616dffb2971b3d59a1f372ec9870"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d62264141d530b64c04b11698c2bf2f0e08fe906c6247e8fc78b14aa8f697411"
    sha256 cellar: :any_skip_relocation, monterey:       "3d7a533e94c2ded66842d08ca132b63aa960f3bda2d852d0b6f308757cb280bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b383fceb63fd840e44cdc2378b62a5129fe209c80618d2c33935a1dd9588f359"
    sha256 cellar: :any_skip_relocation, catalina:       "20fe4d7528c07f392f00c3e18a7b18ae2d37a2775db70a984342727c7655ccee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4be70b426c769b9fe7ee3b8e7bd12791c2eba932b0bc77773eeb306fe57079a"
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
