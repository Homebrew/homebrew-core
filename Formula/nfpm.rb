class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.2.4.tar.gz"
  sha256 "afff55ac4cb4875c6d42bb9f2eed96e942d39ebb7e3c26b27b8ef415ba3525b8"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f480e6586278f8e3871e7d5fd2002e83d9076db04af961ed660c3ff75d3e6594"
    sha256 cellar: :any_skip_relocation, big_sur:       "f4edad78176b2b73c91231fa33c0b10b1e8b3a7b5fa9522d040a32f5ada70f0f"
    sha256 cellar: :any_skip_relocation, catalina:      "f0b0c1091201fe254c14078114c41e2fcead584509d2faeefccaece5fa210aee"
    sha256 cellar: :any_skip_relocation, mojave:        "75fec197442bd4d34a177a11af910efbd15362011fde5f0c5734dfe7a3ef9f4c"
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
