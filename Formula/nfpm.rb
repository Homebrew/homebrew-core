class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.15.0.tar.gz"
  sha256 "2b90e513e180c42c06399faa5a53730c9be93205c3877b14064c4cab3d0c0b4f"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6618311c2c330ca4a0e1afabb92eac3f0d2f3b7efee60a63dc83ab60be839ee2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca0b3df129aee0fa62dc30b9fcb1b4291a6d30ebe8d73b4414d669498fe01e7a"
    sha256 cellar: :any_skip_relocation, monterey:       "8f8ff99cdb76e0a19cc58e40b55ed484329f72a28612c9a3968f6a9a5b9a677b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdcfae561a247d3d64921caf78d77710ddc4362f76ba1799fa9a50ca9535a9bf"
    sha256 cellar: :any_skip_relocation, catalina:       "8bae3aab9ef136152c4901dac29395c8bb1f89465d000acb5fc065befe83c003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "664c9d4c3ec58f25ec9c83d9ee96460f8ced98551dd587cb120dcb9e9045acc4"
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
