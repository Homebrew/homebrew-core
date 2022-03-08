class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.46.0-source/maxima-5.46.0.tar.gz"
  sha256 "7390f06b48da65c9033e8b2f629b978b90056454a54022db7de70e2225aa8b07"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03d83c6ace411ab314dfe956e4fe48a2568f6bdad1da67e8b08d5e1313788632"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "482a2d74f816f9e82fe7eb069dedfc0e3ce7ca74f18849fc665b2ba203882853"
    sha256 cellar: :any_skip_relocation, monterey:       "beeb7254121f0f89e0df46c4cc973217437164a5aa741676d45c4f53271cb550"
    sha256 cellar: :any_skip_relocation, big_sur:        "54c8550b5c03fdece3799275f748fa49fc0aafbc19e53122a64750caf2d4fce2"
    sha256 cellar: :any_skip_relocation, catalina:       "58ec23d7305e07c1483e15ebdc36f82ba23cc38a31ae08f3e749fd1926f33450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "848e854438831923b7d5f479d6b403fb6c4d772231b7242d14927a672a01178b"
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
