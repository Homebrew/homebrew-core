class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.40.0-source/maxima-5.40.0.tar.gz"
  sha256 "74fe468cd372714622a99afb6b34297589ddd80386e125d71067d3e75519f796"

  bottle do
    sha256 "ff618e95bbfe7a33ac4a1f0a7b9e6eae6ea64273c79f0a6b36ff572f20ff887c" => :high_sierra
    sha256 "88719f2b830e0aad79afd54447ee64e07b343a6b4c3c09b2c96f977d92852c08" => :sierra
    sha256 "3e3acb227a04cff58919627634cb403352db48c3f1c37df7d011b57d9924f1ec" => :el_capitan
  end

  depends_on "sbcl" => :build
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
                          "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
