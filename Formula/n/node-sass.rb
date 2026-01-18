class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.97.2.tgz"
  sha256 "3ce2590da29820f80eb41a851c644ad196389f389ffb55efb950021c692c968b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce49aa93f30f8100ac1bc858bcb11bfb379a50a1ce047cb6ba3bdc7c9501b977"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce49aa93f30f8100ac1bc858bcb11bfb379a50a1ce047cb6ba3bdc7c9501b977"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce49aa93f30f8100ac1bc858bcb11bfb379a50a1ce047cb6ba3bdc7c9501b977"
    sha256 cellar: :any_skip_relocation, sonoma:        "3568a5fa15d0f2508cc85a0cdd4abf2efd0a5abc47090c19101280d7d9417240"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "048c7c4fa48136fa07d839181b59a9cd63a268d391f89d5e13703ef13b3da3bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3d2ad0d2e5e10124ec29d24f847b6e1009a18401f521c5ebe72ad28726d11dc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
