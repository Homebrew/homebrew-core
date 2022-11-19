class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager.git",
      tag:      "v1.10.1",
      revision: "a96bae172ddb1fcd4b57f1859ab9d1a9e94f7451"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b725d1aff09b603e8e8495e04032e380b77ce4b8fd49f31be6a32841bc8fde1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b519910c4e72958e8c7a84097c12fcf768f6bc06b2bbafd1c72132d61b14a3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e40efa142e148a54b12978dbbf5b1d0af1b0a2052ce6687d63c5d64c8609b0bf"
    sha256 cellar: :any_skip_relocation, monterey:       "349a8837c81769de0fe34b3bb5be12707b196b849380ebcea6f08c5a8b3df73e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9a71c53738f6a462a814b304fe4cfb71bc285daa2d9449b0fea87a3771db124"
    sha256 cellar: :any_skip_relocation, catalina:       "26ed49d536e494e164590003d9c5ed54327c5eab0d45babfb4b22b18dd00341f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e91a4bc3b20760db2c82d849a6d2a7a4f000f69be6eadf84b39d15c4b6bb241c"
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
