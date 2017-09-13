class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.38.1-source/maxima-5.38.1.tar.gz"
  sha256 "0e866536ab5847ec045ba013570f80f36206ca6ce07a5d13987010bcb321c6dc"

  bottle do
    sha256 "0a1c186375b35420a55590187655ac4a0160c8faf76750f4b156febf25665c4e" => :sierra
    sha256 "5c9f091e0d6993bffb750378076d5d05fe525fe2dafd7af85652c421e840f814" => :el_capitan
    sha256 "96e042b2ff652ffdbc1b10236a119240bdf6ae5c29389c7d3e9f01ee3721aa7e" => :yosemite
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
