class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.5.1",
      revision: "c3e4d8b7cd2f6f065941510b260f173b70c695fa"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7708cda4c0cbfba9779bcbba178db6c21fc8b21d0fa728f9956f516363475b7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50e0278b6e432b4c31eabc187f23473b7d7d0df6077f5523e9a6bd42bdff8bad"
    sha256 cellar: :any_skip_relocation, monterey:       "cdba3052165d946cc859f273c256c791abcb3ba7c4e573d91ae823cc0901f701"
    sha256 cellar: :any_skip_relocation, big_sur:        "b15bdb43aa15d93550c22192ce356bf259c4516ddc438b405509c8a87c0fef1d"
    sha256 cellar: :any_skip_relocation, catalina:       "85392cd349a0a57f83124e07aa8aed0f453fd4b222ee126bf804154c3902e8df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d87b5f9bab45657233a5cdfa74137cc1e3302a93177b19e46aac18ba1c719564"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/sigstore/cosign/pkg/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.GitVersion=#{version}
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

    assert_match version.to_s, shell_output(bin/"cosign version")
  end
end
