class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.44.0-source/maxima-5.44.0.tar.gz"
  sha256 "d93f5e48c4daf8f085d609cb3c7b0bdf342c667fd04cf750c846426874c9d2ec"
  license "GPL-2.0"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "49bdc3f26a3979633b7c232380c93566af03401683a2870fb25e3ea40a18951f" => :big_sur
    sha256 "1b38264f8b5f867034d238be3fea3e8a3c30004f8b2fe5997e73dff3ccc5f7d6" => :catalina
    sha256 "5a9a0e9bcffbce0871cb0e0756ce110d03129f0a2784798890766eb6c9a82c67" => :mojave
    sha256 "96772653ca25c724239a4902a5a0f8844a8b71f2290e25824eec75d032148f98" => :high_sierra
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
