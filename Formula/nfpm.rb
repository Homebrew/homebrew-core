class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.17.0.tar.gz"
  sha256 "b4775fc5e7317564ce98ae4fccd45981e611de531320b9e42cd2b37cc5c67a25"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d111bd2d627fd45c4b77bf21403cf1f0ab2a0e404231a3b971f789e5d8e45430"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9532ff55e0f7df0cd04251f1f4aaf02825bf8efb222e8370b341d042c86fcdf"
    sha256 cellar: :any_skip_relocation, monterey:       "24beaf2d3557403a5235bce05fb43d3459d43cc0d9737cda27c8d75c04f5e881"
    sha256 cellar: :any_skip_relocation, big_sur:        "977e7154765786bd1f6dc42dac2c78a54cb043d7656786855c76c0d775be6e14"
    sha256 cellar: :any_skip_relocation, catalina:       "af90e7428824bcee5d7c35a5be3581b3efad75a5fdb20add26082eb46bcf1137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e1d3d2321dd3b60135509a1af7407f0fd8fa98fe634257d93ef9b61a44336f7"
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
