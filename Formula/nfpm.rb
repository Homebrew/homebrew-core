class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v1.10.3.tar.gz"
  sha256 "554b02fff1eb000a500bc5a0667c548bfebed6d70ee6daefa77a49f0748bf096"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf8b5f031fe3f65b13b89f1af11a914baa4d4a698754760de4a0dc00442c99e0" => :big_sur
    sha256 "ca8a56ed0694ee1e5a810835405d4b0c858d8495f2ef2785e4978f64879c45f6" => :catalina
    sha256 "e1f213c3f27498cceb0a674b50bdbddaa964b6a403f8b1c513ce7fb52b9134fe" => :mojave
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
