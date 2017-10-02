class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.40.0-source/maxima-5.40.0.tar.gz"
  sha256 "74fe468cd372714622a99afb6b34297589ddd80386e125d71067d3e75519f796"

  bottle do
    sha256 "26087570ccabe210be2df29b21a60a6c3cb9d0efd61ef6ff314d4844c8cf237c" => :high_sierra
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
