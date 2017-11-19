class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.0.tar.gz"
  sha256 "61958f998d4618e09ce0dd473411921818d13df838f32102ef5ded984a0d1a50"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "25b84a658f502488cca76e239d007e1b6dfbfb6530432ab689f1145768f9cb4b" => :high_sierra
    sha256 "9b89140e2250337d7329da7b6b67c930b62b5135104e5316c6aab53a593dea3f" => :sierra
    sha256 "25459196d45e18f85377194a61678e31f344e8ea91c1e2d10ddf40322e763c72" => :el_capitan
    sha256 "25459196d45e18f85377194a61678e31f344e8ea91c1e2d10ddf40322e763c72" => :yosemite
  end

  option "with-docs", "Build manpages and HTML docs"

  depends_on "pyqt"
  depends_on :python3
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
