class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.7.tar.gz"
  sha256 "3e090120f6c46c9a765273ff16a86162d39b79f53f4bbdcf5362c425e57dd904"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15a61e00cdef13bbd6212995f546b6bf378b63977eb5ec68fe8795579bc5ea6c" => :el_capitan
    sha256 "b1bc2f5e4b1e005f986d481489e7a86cd004c99c687eb46cbce39b008e904435" => :yosemite
    sha256 "4ddaab7791abb66ce6f982f55a775e8369e4714ac9412b1b5129f52252d7a086" => :mavericks
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
