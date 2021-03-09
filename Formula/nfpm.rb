class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.3.1.tar.gz"
  sha256 "56193d06cb830c347c23ba912fb71711d5292a673b3e77ddc5b23e51103e61ce"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34d99ff06ab25347678c4b0a53394d35a7845ba09c3beb533b101375d149e2d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "d6bf1106a37a47296953b64c6bef02da7b6d1f90a6facea825f8121f78b52df2"
    sha256 cellar: :any_skip_relocation, catalina:      "b33b40f6cbbdb62a4fe20b602a3ac2bffa4fee09e87d7d2422fc667894c9ecf9"
    sha256 cellar: :any_skip_relocation, mojave:        "7d5e892e5330016f351d1a9ead1405034afc8aec8d882b640ecb5add47baf16d"
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
