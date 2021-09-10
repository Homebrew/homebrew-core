class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.45.1-source/maxima-5.45.1.tar.gz"
  sha256 "fe9016276970bef214a1a244348558644514d7fdfaa4fc8b9d0e87afcbb4e7dc"
  license "GPL-2.0-only"
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e987b77c2655f903220128bc5deaf8f707db4e7ac9127f5dd452022dd4282377"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d8d2354c2b81a70a9c534012940650eaa14840bf458855d87c61788136d25d3"
    sha256 cellar: :any_skip_relocation, catalina:      "aceb2ad6b6e543a7a23dab189f69e2e2d5d3f7219ab5e445c55c8c3ea5861c25"
    sha256 cellar: :any_skip_relocation, mojave:        "0c9f5d1efe7ea53f85b2b93bec43690cb5da025e1b864b6d963ce58d5a74e852"
  end

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "perl" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"
  depends_on "sbcl"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--enable-gettext",
           "--enable-sbcl",
           "--with-emacs-prefix=#{share}/emacs/site-lisp/#{name}",
           "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
