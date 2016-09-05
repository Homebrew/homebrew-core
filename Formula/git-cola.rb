class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.8.tar.gz"
  sha256 "9962098bb73c2c13ea32ded01821e447e0c9fbece3d213eaccf6bb02413ccea5"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d29b308da9c68a21752c1cbb37a987ef3342d9549c4695c85474d1b5b7b1145" => :el_capitan
    sha256 "063219095e2e6714e1fba8cb96428b7555ccb608a0970ed441b85033ba9411aa" => :yosemite
    sha256 "063219095e2e6714e1fba8cb96428b7555ccb608a0970ed441b85033ba9411aa" => :mavericks
  end

  option "with-docs", "Build manpages and HTML docs"

  depends_on "pyqt"
  depends_on "sphinx-doc" => :build if build.with? "docs"

  def install
    system "make", "prefix=#{prefix}", "install"

    if build.with? "docs"
      system "make", "install-doc", "prefix=#{prefix}",
             "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
    end
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
