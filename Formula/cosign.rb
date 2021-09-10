class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.1.0",
      revision: "67934a685ddc83aa7b0b8a55c911e299117afac5"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f91b1892985a3dbf1fe6829e75112edf3f86917fbcf24666ab57af5d00eb186"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e46a3bf9917d94a864a025f177d2a5e7738bc427fedabf3ef384f8db6e25ded"
    sha256 cellar: :any_skip_relocation, catalina:      "67a58dc5eaf1eccd3e2594ed9a389c338953bd71f34de66f8084fdc6facab7c9"
    sha256 cellar: :any_skip_relocation, mojave:        "aba1771020c0febd033d7d05f88b0308a43b28108312f15f80cc4c175e0839af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbd943a769c628a5999ff912450b47aee0737266d4997656dea083730ad64574"
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
