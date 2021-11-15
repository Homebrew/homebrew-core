class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.3.1",
      revision: "645ebf09fc555762a0494baa30edc08c38435368"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d65c32d8c9404a625735d19e64e098d2f5717064f25e2f87ba753abcf11e157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ca3230e797c482b3c87a2195a5ab413dc5b989dc91b9fd6c22ecfd2f5eb2d26"
    sha256 cellar: :any_skip_relocation, monterey:       "caa5866cc23ebfde014c1acff41370624a44cf4c4c9d5c3de25c54d90b370677"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e941c0b9a48fe9c576d24227b119720da42f3537e918cce611aaf5efbd129db"
    sha256 cellar: :any_skip_relocation, catalina:       "0f98985d5471e542c8aeea005921399bf6b76c7aaa08bb46745201293ff782ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be7273e83d70343a05bb91bcd15a9b54abbfe13ef0a0dee51da8813a01d144fd"
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
