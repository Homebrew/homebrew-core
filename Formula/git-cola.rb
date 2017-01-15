class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.10.tar.gz"
  sha256 "fd310087ad4c4ccd22829ae319d9409ea3ff872f5391b999de130faaf77f4e1c"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2cd63a33cbea24cd5c17efe72c54e538443113aae3d3f7fc204bbd30bf9360e" => :sierra
    sha256 "b8d0b83f12bb03056fba491b78ca632b73377e9a444f026585b7ac5a75e8553f" => :el_capitan
    sha256 "b8d0b83f12bb03056fba491b78ca632b73377e9a444f026585b7ac5a75e8553f" => :yosemite
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
