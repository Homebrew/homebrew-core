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
    sha256 "d5e72dde0b6ea555a8daae7c873d58a5c97ddbf6ac499b41239f10dc3aff94a9" => :big_sur
    sha256 "20b6f47d793bb85dff6f5b1a8b6df25c9184043657d1d18552a4d582e1f903a9" => :arm64_big_sur
    sha256 "ef1c8b2bcaf9de6249a46bfc97ab24f048f5b9051c2d8290614fce3d5c8edfef" => :catalina
    sha256 "18ff1bd2601835ab966f635680470031912913593d8a28cdeba9e92effcb7418" => :mojave
    sha256 "64f4ec4531a6f96370748a586dfe81fe134ae24c0292f7429043e8eeb7ac64f3" => :high_sierra
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
