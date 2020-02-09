class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.43.2-source/maxima-5.43.2.tar.gz"
  sha256 "ea78ec8c674c9293621ab8af6e44fbc3d869d63ae594c105abdffedef2fb77bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "4828f5a5e901c48c225a182d85f8b5c4c3e0f5316e4ca6c7bf49e09710899c7c" => :catalina
    sha256 "e1154e085eaf5716065a682f0d739b7b3adfbf2697826469b69430a503581c47" => :mojave
    sha256 "2cc7a70a750ca77527db7664e7e53790cf3cf07f6f090d18e6e1320b0f9bde7e" => :high_sierra
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
