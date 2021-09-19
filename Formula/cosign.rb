class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.2.0",
      revision: "aa5d23b86d09c2275dd3a7317b7c98cc30a8eee7"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3457de19da5c9e33db370320991b35513a73143556a3942b88acd42be6fb6ae2"
    sha256 cellar: :any_skip_relocation, big_sur:       "39df85539a9c54458f02c7ff68c8b8d80448e2578d5485f9b0afcce27b14b74c"
    sha256 cellar: :any_skip_relocation, catalina:      "cf6bc8cf52162ff615d927da8dc5d6bcd0b0021f5e241ba4f882377b04b208d7"
    sha256 cellar: :any_skip_relocation, mojave:        "33a6c630d0c350e5bf04e0e6deb1defeecc431ba1d5150b7ff8b28009dd5d9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "808d390913e5e796145962255fd05d835deecd866cbc5f9ddcb60dd0c06b5b76"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/sigstore/cosign/cmd/cosign/cli"
    ldflags = %W[
      -s -w
      -X #{pkg}.GitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState="clean"
      -X #{pkg}.buildDate=#{time.iso8601}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cosign"
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version")
  end
end
