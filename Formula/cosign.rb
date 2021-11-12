class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.3.1",
      revision: "645ebf09fc555762a0494baa30edc08c38435368"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a294732dd772988a02771cecf8d6c2796af18abe93670b9ac844c9f8e94a408e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d2fc8933b09095683fad9c6ccf3fe30b42c174fb20379ec233ab3e71c97095a"
    sha256 cellar: :any_skip_relocation, monterey:       "1a2f5792632bb82870bb0900e9cbd33bbb40366492740b33966a82971d7e516c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3aa02b3c736440f849a1fbfa2f41f5008815f0ca65b03b356eebc58d69fd2924"
    sha256 cellar: :any_skip_relocation, catalina:       "bda996e03a78e48877a24ec67a7ee1f2c0bd6bacd1e594ec4bae89363a566993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d9d5c810fd20e6520a5cb05c78194410c0a31b35e15fef2fdf9bba84ae598e"
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
