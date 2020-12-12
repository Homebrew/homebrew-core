class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v1.10.3.tar.gz"
  sha256 "554b02fff1eb000a500bc5a0667c548bfebed6d70ee6daefa77a49f0748bf096"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5794d738ac4212008a83ceadd2cfd8e64f2c22090e7cab79f558da57ea507dad" => :big_sur
    sha256 "6b2320aee6e3e657eab5fd8fbfb754201c49e5844e5e74b8691214c656766bbd" => :catalina
    sha256 "c827ec17d5b6fff7483e6a0723e5eee8569e2cb735ed4518e87985c3f44c16b4" => :mojave
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
