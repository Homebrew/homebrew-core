class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.10.tar.gz"
  sha256 "fd310087ad4c4ccd22829ae319d9409ea3ff872f5391b999de130faaf77f4e1c"
  revision 2
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "749064be00fa1040b2ec94c4e0c98e9b21fd87f4ff7a046c1673318ffad64cb6" => :sierra
    sha256 "b3b07496defb7064c0b0944f1baf59da4e968400c085055f139b11b6ff3922a8" => :el_capitan
    sha256 "749064be00fa1040b2ec94c4e0c98e9b21fd87f4ff7a046c1673318ffad64cb6" => :yosemite
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
