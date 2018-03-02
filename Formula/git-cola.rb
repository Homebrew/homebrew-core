class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.0.tar.gz"
  sha256 "61958f998d4618e09ce0dd473411921818d13df838f32102ef5ded984a0d1a50"
  revision 2
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ee403537d80c7edf3fc250c5b19bf49d8687c9dbc3d34eda979a7d921aaf9f4" => :high_sierra
    sha256 "1ee403537d80c7edf3fc250c5b19bf49d8687c9dbc3d34eda979a7d921aaf9f4" => :sierra
    sha256 "1ee403537d80c7edf3fc250c5b19bf49d8687c9dbc3d34eda979a7d921aaf9f4" => :el_capitan
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
