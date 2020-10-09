class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.8.tar.gz"
  sha256 "ea482ca32fe142ddba500d2edf3a05f11e31cf193e5d7a944f3fe28c9ab123d4"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "989ec95daf9c3169b09f240affb4754e9e11e5deef4a11ea7be7c52b83918618" => :catalina
    sha256 "aff773374a3ed5e14c28e285c83dcf62daea74701605fd1a870669851b3dab84" => :mojave
    sha256 "968bf6da6d49fdb2d0aad015432670c18fe6c7b522f2c57bf3b1588f5190a6de" => :high_sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "pyqt"
  depends_on "python@3.9"

  uses_from_macos "rsync"

  def install
    ENV.delete("PYTHONPATH")
    system "make", "PYTHON=#{Formula["python@3.9"].opt_bin}/python3", "prefix=#{prefix}", "install"
    system "make", "install-doc", "PYTHON=#{Formula["python@3.9"].opt_bin}/python3}", "prefix=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
