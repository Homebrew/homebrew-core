class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.2.tar.gz"
  sha256 "4005e714db78b073c1ef8bde55485452dc7a31e3b8cc0b4d60d6112ffb5ea228"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c4a826b8c3353e706e810d53eaebd0a24411054c5ccb4dd27634b0449af5129" => :high_sierra
    sha256 "5c4a826b8c3353e706e810d53eaebd0a24411054c5ccb4dd27634b0449af5129" => :sierra
    sha256 "5c4a826b8c3353e706e810d53eaebd0a24411054c5ccb4dd27634b0449af5129" => :el_capitan
  end

  option "with-docs", "Build manpages and HTML docs"

  depends_on "pyqt"
  depends_on "python"
  depends_on "sphinx-doc" => :build if build.with? "docs"

  def install
    ENV.delete("PYTHONPATH")
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
