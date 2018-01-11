class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.0.tar.gz"
  sha256 "61958f998d4618e09ce0dd473411921818d13df838f32102ef5ded984a0d1a50"
  revision 1
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a38fc0631769bcf34b3a31c6d0021e980801b73cd08f053057e6854ebb947fdb" => :high_sierra
    sha256 "a38fc0631769bcf34b3a31c6d0021e980801b73cd08f053057e6854ebb947fdb" => :sierra
    sha256 "a38fc0631769bcf34b3a31c6d0021e980801b73cd08f053057e6854ebb947fdb" => :el_capitan
  end

  option "with-docs", "Build manpages and HTML docs"

  depends_on "pyqt"
  depends_on "python3"
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
