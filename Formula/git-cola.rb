class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.10.tar.gz"
  sha256 "fd310087ad4c4ccd22829ae319d9409ea3ff872f5391b999de130faaf77f4e1c"
  revision 1
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c742348a63a6e34d0c52bcd489b1e843bf801a9d2ed942f85d4081ad4aceeb96" => :sierra
    sha256 "f0be7e1fbae9d40b3a4134f5c5774b1598731e32832b4b753bcf74ebb7b625c1" => :el_capitan
    sha256 "f0be7e1fbae9d40b3a4134f5c5774b1598731e32832b4b753bcf74ebb7b625c1" => :yosemite
  end

  option "with-docs", "Build manpages and HTML docs"

  depends_on "pyqt5"
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
