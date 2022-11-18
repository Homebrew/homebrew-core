class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.22.1.tar.gz"
  sha256 "8bd267c9a64d9e0a208a20ddc5a918630a4347b8bcdcf4a8d35f7b77b303393f"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7463da73cab67a9e2fcb7bfa6a59d15fb16b9a49b40f5d6e9cdf2dfc4a93ff6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7f45bb6e2664f41c335a5f3d29f66143af2761bf59a04b4f33141dd7b93bd7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "934b4b1cfa6eb9ad40c03296c71cb1ca1ea07bee1c3f3da4c1592c3bb42468f2"
    sha256 cellar: :any_skip_relocation, monterey:       "ec0b10a43bcad4a75a13ad3c6231a4cf3e2c8a13422b5a2c15a7b16d21080a0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "60f74a8a4784c0fea10330e6e6bbda16ad66b35cf3cf362aaca91f8edd898d1d"
    sha256 cellar: :any_skip_relocation, catalina:       "f40d4e5a301d85480c637d67c061298b9b23f18ea9484af5f29d0b617b6de964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca7feaa2f077b4ab7ac8a1dc3b300e99bad861e8850ba6b5902cd71b735ddf0f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"
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
