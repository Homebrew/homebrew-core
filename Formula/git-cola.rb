class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.7.tar.gz"
  sha256 "3e090120f6c46c9a765273ff16a86162d39b79f53f4bbdcf5362c425e57dd904"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "581410959c98c1b223334eb0d7c2938ef2549044dcdf663d9824d0f1c7182252" => :el_capitan
    sha256 "be7c12091cc413e5e5173aca38668211c64e76256f2d95486504de6bbb2d0e77" => :yosemite
    sha256 "bd8b4c704efb91dd35236c2e86719d6a0e27324595c35744f75bbc7767922e3e" => :mavericks
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
