class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.5.1.tar.gz"
  sha256 "234421fa5797ee17c1072591c3194434a118dfdb5036bc06d99912832cb36367"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6324945bd6ad350b3de88aafef7ddaacf000e9c0e2f4e5131d25a4ed55861b7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "7e89b849f1813a61ad35d97bdf6ac53013e6e8d69c29c148d9c0a9b25b654c8b"
    sha256 cellar: :any_skip_relocation, catalina:      "31207573f8fc526d53a2629a48f06016d50717b0a470b970ee7397cc12787ba4"
    sha256 cellar: :any_skip_relocation, mojave:        "11a4d640aeda2ef0d3c95c6712128ddb81d867660d44839d2aa05bdc71148793"
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
