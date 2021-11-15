class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.9.2.tar.gz"
  sha256 "74d3c6b6f52fbfbb2d634c27cd9fa3aea46ba2a98763351b52d7478040e8e162"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e198dd863bfaee6301b79057ee901503ead7177baf0650ded5e2ffd7db702a0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b2745937b4c880fdafd9aac1723549313924dd90c26add7da5ad8a5ddccc2f8"
    sha256 cellar: :any_skip_relocation, monterey:       "c99cfb1cbe06490adf256ffdf1c1c3a87663549d2b1f415aea981f96ba028797"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce20ed4aa1587e0de5cd65cf4cabf17b821c5ccc37b3881722b6f9fb26b3d956"
    sha256 cellar: :any_skip_relocation, catalina:       "f7fd5479c587f59ecce2d461b227f0756f942c8caf52021ef97dfba7f5d647d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab5554582b86a02a54d13d6a670f548c67ae3e5ae87a347ea71fed6a5e5a4b4"
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
