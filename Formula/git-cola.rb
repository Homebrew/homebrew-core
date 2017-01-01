class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.9.1.tar.gz"
  sha256 "41fbd774f43b8d5a5c874e2a6f28a447043ddd40c691f10dfa68d533bed8180a"
  revision 1
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
