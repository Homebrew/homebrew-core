class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.2.2.tar.gz"
  sha256 "309a8760f1f329ab1a56a0ad8240e447e5bbcd60a7e1c7f9d24830ff10b89b84"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e06aefbef3da540181206325ddebed7712bf43ffe307ad6802438cf5eaf84f9c" => :big_sur
    sha256 "cb89330466d60841270629c42f3d192d4b4b118afffb803ec4e2b2872c9a76c7" => :arm64_big_sur
    sha256 "d6be6a3d4ddacaca2fee655f566c95cfde762a45473eac4ecccd98a8bf9eb7e4" => :catalina
    sha256 "606ecb9b7c2b0f52b47a02c9c625709f0352bbba7e3c066c68ce8a75b05f71f6" => :mojave
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
