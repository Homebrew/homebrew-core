class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.4.tar.gz"
  sha256 "763e382d8b32427539585d17ec6fe92026c073f6d31a864a5816ebe22cf245bc"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "833bb6fc9782c38d57028fef7556c3750066d5d4dd6982b0593f72f2bf7a5311" => :mojave
    sha256 "833bb6fc9782c38d57028fef7556c3750066d5d4dd6982b0593f72f2bf7a5311" => :high_sierra
    sha256 "cddad576614177c901869aa64a2a103b4f68b3c94c760d75665f8529d004ece7" => :sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "pyqt"
  depends_on "python"

  def install
    ENV.delete("PYTHONPATH")
    system "make", "PYTHON=python3", "prefix=#{prefix}", "install"
    system "make", "install-doc", "PYTHON=python3", "prefix=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
