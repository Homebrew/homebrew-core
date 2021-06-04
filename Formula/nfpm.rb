class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.5.1.tar.gz"
  sha256 "234421fa5797ee17c1072591c3194434a118dfdb5036bc06d99912832cb36367"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "97cd4fd4678030246d6e46cb20cfe51501de296284690c1a96e6178f562bd58e"
    sha256 cellar: :any_skip_relocation, big_sur:       "a06597c1f08009dc18906cb20426e4b41037548ae5a1327c06e977cb69762eeb"
    sha256 cellar: :any_skip_relocation, catalina:      "2ebbd914efcbf82cc4d6d78ffa8754560ffac23d8a2a452732ca797183a3ab2f"
    sha256 cellar: :any_skip_relocation, mojave:        "82ebacec0af9bff4cebb0ef593fbbce1dc7d6254fb2421069d2ff3c74d6158ac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.version=v#{version}", *std_go_args, "./cmd/nfpm"
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example config file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end
