class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.6.0.tar.gz"
  sha256 "d5d4433e4a2767f990bec48845dd8f04839ea13989271a67674821737713af91"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "11cc7fe2db9485e1823d15379796c9fcb4b9414cc830fa5d18d55230f96e4365"
    sha256 cellar: :any_skip_relocation, big_sur:       "f94b0b5098dbf8a031916f9531760a2eb09a49ef5f58e9d38ff80a20f6a053d9"
    sha256 cellar: :any_skip_relocation, catalina:      "b37c0e27d6f4e2f52a51335c11bf01eea3f710948d35e2a6eb46d8e79aa04176"
    sha256 cellar: :any_skip_relocation, mojave:        "59675cc7634574f6df007cb48a85a4e334eb1ede73386c68bf96f2640014c8e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e83c3694f29669594ed1d0e0664ab03356da8da2a2a73386c2c21244358cc03"
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
