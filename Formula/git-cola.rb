class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.2.tar.gz"
  sha256 "4005e714db78b073c1ef8bde55485452dc7a31e3b8cc0b4d60d6112ffb5ea228"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23f64ddbebe8299219d29c41c024b7b8af65f1fb949458997f04d52557d77bf5" => :high_sierra
    sha256 "23f64ddbebe8299219d29c41c024b7b8af65f1fb949458997f04d52557d77bf5" => :sierra
    sha256 "23f64ddbebe8299219d29c41c024b7b8af65f1fb949458997f04d52557d77bf5" => :el_capitan
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
