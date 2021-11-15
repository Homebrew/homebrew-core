class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.9.2.tar.gz"
  sha256 "74d3c6b6f52fbfbb2d634c27cd9fa3aea46ba2a98763351b52d7478040e8e162"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2340350346f42424299b45743019fcd016e1446d420d0f8cecb46455c208cc57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f782c6e482716b8d4410139cd30a0fadc6b7167909a4d92eb4537b6a92b3fbdf"
    sha256 cellar: :any_skip_relocation, monterey:       "fdc125a3be2f55c758f7fe30ded616ef6287afab27aef3014219a26241afb14f"
    sha256 cellar: :any_skip_relocation, big_sur:        "69d6b286378426c1bc840a8b2b81e644ce47f89c7647b6f99485e57e6553889d"
    sha256 cellar: :any_skip_relocation, catalina:       "999111737a6ee5e1d4af43eb14008b3d40055a224e961fa80364a1ee68fd4b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f484aff5f03ff5ba496308290e4cd5bacef74ac168b4cdf47f010211dbf27b95"
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
