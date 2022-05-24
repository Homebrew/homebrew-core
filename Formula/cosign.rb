class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.8.0",
      revision: "9ef6b207218572b3257a5b4251418d75569baaae"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e41f2d5d02f3f52b46bb91ee2d2fc3eaad8f630953d32f061dad62f0bf36419e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9525e88fd1186b6f86e6bc17e331ee74e534b602955545afee5790d95f7ecb85"
    sha256 cellar: :any_skip_relocation, monterey:       "0dd5cbb0d6b8be42fdeb59a01a72b06fd0efab055f6afac96e8be07655643090"
    sha256 cellar: :any_skip_relocation, big_sur:        "879b88e2067a8d6ee13687ebf7a93e9142ea604c89308e62090f52114df0e3d1"
    sha256 cellar: :any_skip_relocation, catalina:       "34d1f3429665d336ebd0f228deeff949b4e0280857762245de97b8271a520bfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee0b3f1ec3bb1a78d340abc37eb1efcc21830a5adfea31b0b3a3e87a902db46b"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState="clean"
      -X #{pkg}.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cosign"
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end
