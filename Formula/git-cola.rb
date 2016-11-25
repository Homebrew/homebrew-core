class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.9.1.tar.gz"
  sha256 "41fbd774f43b8d5a5c874e2a6f28a447043ddd40c691f10dfa68d533bed8180a"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "add4de977eea09355dd42727cde11d8e97fd83039846f84a290411d57689b817" => :sierra
    sha256 "add4de977eea09355dd42727cde11d8e97fd83039846f84a290411d57689b817" => :el_capitan
    sha256 "add4de977eea09355dd42727cde11d8e97fd83039846f84a290411d57689b817" => :yosemite
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
