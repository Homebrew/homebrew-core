class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.43.2-source/maxima-5.43.2.tar.gz"
  sha256 "ea78ec8c674c9293621ab8af6e44fbc3d869d63ae594c105abdffedef2fb77bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f114e3e8e81a92098679cfe317249b34b30487942dc1188c29f1bb4d47ae234" => :catalina
    sha256 "2ba4476c009fdc87633fc27f55b344b20920b6daf14ee0c0b6afc58af66d819b" => :mojave
    sha256 "3b8a7c561dc3d11c0fd96fdef341f58a05a4b1d51f045b4e78a28bd9ef478383" => :high_sierra
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
