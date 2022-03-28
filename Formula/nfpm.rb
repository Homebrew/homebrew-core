class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.15.1.tar.gz"
  sha256 "ce43c832311f3e8ce0432d6e7a72e91789705de309cfb42883e496d57f56bcec"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7c74bce2a5f2c329db648ada214be2ea961c51ec1bbe782a91c2892b272df63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8141e5e97b0644fc74825afd837184cde79f722b87380901a0cd985e6393f28a"
    sha256 cellar: :any_skip_relocation, monterey:       "bde98609935af4d9954117e55dfe23186901526b858c84c86e116cab31f3c1dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "38b40a214be3e5bbbfe942ecdf6b760e8cc125653e8028eea6d3fcc95bee5205"
    sha256 cellar: :any_skip_relocation, catalina:       "0eb46ec12ea9b1902c6619444c649dbf03d7c7e5116a97ad83a68c33a756abc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3c0e88b4acdc4a6f0df2e2eedf9cf578462ab5d85f050679ef3d3dd1254ebb6"
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
