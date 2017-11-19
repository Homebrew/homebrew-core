class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.0.tar.gz"
  sha256 "61958f998d4618e09ce0dd473411921818d13df838f32102ef5ded984a0d1a50"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2aaadd48e3fc112c3e20a366ab798de2d76c965a2f5e2acc5922444a1efec1b8" => :high_sierra
    sha256 "2aaadd48e3fc112c3e20a366ab798de2d76c965a2f5e2acc5922444a1efec1b8" => :sierra
    sha256 "2aaadd48e3fc112c3e20a366ab798de2d76c965a2f5e2acc5922444a1efec1b8" => :el_capitan
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
