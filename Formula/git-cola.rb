class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.11.tar.gz"
  sha256 "bc4007e0d9c80763ef58d630b033bfdbd8406af77bbd292a6c647ed3ca655b5b"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b89140e2250337d7329da7b6b67c930b62b5135104e5316c6aab53a593dea3f" => :sierra
    sha256 "25459196d45e18f85377194a61678e31f344e8ea91c1e2d10ddf40322e763c72" => :el_capitan
    sha256 "25459196d45e18f85377194a61678e31f344e8ea91c1e2d10ddf40322e763c72" => :yosemite
  end

  option "with-docs", "Build manpages and HTML docs"

  depends_on "pyqt"
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
