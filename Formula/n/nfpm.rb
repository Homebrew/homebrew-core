class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.35.3.tar.gz"
  sha256 "a3097a87d7ec4bfbd92600c441cfc6147122c5ad3597ca8742b8d4020711184b"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "537e57e5075155ce0638a9b69019f7b52edd7f18242ba340b18ddc32c57a3d4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c2e58b322c152602d98f4b60be4bfac844f3241596b1a3ba31711909f757249"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31984333ef00dc470d1957b47a62245b1057d95aef1cfa4d63a2a25f8bc870ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "86b011febd200ab831818ec7de451b4a1e6286a54ac6fe6f461302a0d25d9b11"
    sha256 cellar: :any_skip_relocation, ventura:        "a6d4f71ca199f270f972172fe292b206ef852ea728159381a477e941e923f73b"
    sha256 cellar: :any_skip_relocation, monterey:       "77365edaa3dce63cda0d5e333595b3f0a9d107db13e06f31b7f9afa5d4f14953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd4466b3cd5109e72b6f7cda84a936aa70144bf4c1946eb68e42cc3e673f556d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", "completion")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example configuration file", File.read(testpath/"nfpm.yaml")

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
