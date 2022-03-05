class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.6.0",
      revision: "4b2c3c0c8ee97f31b9dac3859b40e0a48b8648ee"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12b87ab081c298504d49e9a1f800c63b69555caf1d08230dda0becb841afc90f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "267e562453216fb8aab4c1c551163f6da3ba303ec48a0834492f8e85c70e8b59"
    sha256 cellar: :any_skip_relocation, monterey:       "cb854addbbf8e798d1cd8cb9a91e0ff944c0807189bd12dfcc3dd08eac9a84cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "12dbd9cd66eeee26ad870deb60833a81f2a8eec700a11b36df6fe2dfcef041e7"
    sha256 cellar: :any_skip_relocation, catalina:       "313ac6f45cf96c17d6416692672b6377a91c65c1c2d75211bf1b1abaacb65ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dae40a1fa2769d233865f883621832212bfb6f8fd7037c7dfae888f7dad2f23"
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
