class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.10.tar.gz"
  sha256 "fd310087ad4c4ccd22829ae319d9409ea3ff872f5391b999de130faaf77f4e1c"
  revision 2
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "583b018b3a58252c68d285c05573dda3dbaa596ad6758d96141c9cc0964d018a" => :sierra
    sha256 "1546ef77c36c957c2c6d9211053ea2de5d537c9d672dfc2abc26ea1684790e34" => :el_capitan
    sha256 "1546ef77c36c957c2c6d9211053ea2de5d537c9d672dfc2abc26ea1684790e34" => :yosemite
  end

  option "with-docs", "Build manpages and HTML docs"

  depends_on "pyqt"
  depends_on :python3
  depends_on "sphinx-doc" => :build if build.with? "docs"

  def install
    system "make", "PYTHON=python3", "prefix=#{prefix}", "install"

    if build.with? "docs"
      system "make", "install-doc", "PYTHON=python3", "prefix=#{prefix}",
             "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
    end
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
