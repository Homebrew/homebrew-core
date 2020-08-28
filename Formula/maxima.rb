class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.44.0-source/maxima-5.44.0.tar.gz"
  sha256 "d93f5e48c4daf8f085d609cb3c7b0bdf342c667fd04cf750c846426874c9d2ec"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f873f22d3e0540feb2a696cb2ec18ca7786742ae2a00faafcce968bbda56e5a9" => :catalina
    sha256 "b6d47595e2d411752408890c331efba31819cc006284b849d8473f80dfa12948" => :mojave
    sha256 "bb6196d4dafeacd3060782b7d46e32df9281cb8d0c5d4eb5ea280c3531ab0ab3" => :high_sierra
  end

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "perl" => :build
  depends_on "sbcl" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gettext",
                          "--enable-sbcl",
                          "--enable-sbcl-exec",
                          "--with-emacs-prefix=#{share}/emacs/site-lisp/#{name}",
                          "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
