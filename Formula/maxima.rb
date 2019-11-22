class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.43.0-source/maxima-5.43.0.tar.gz"
  sha256 "dcfda54511035276fd074ac736e97d41905171e43a5802bb820914c3c885ca77"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e0dd3068febc291a3806eacb7501e739dbff8c26abbfb126388e0c61b4984c2" => :catalina
    sha256 "aa7bf5470e9e6dc540338417bab19f9f30cce70d6d9c337e9277d7c1ff8162a0" => :mojave
    sha256 "a1d945ec5aed4fe25d784cfdf0982cd5ebca17ea677a8b3c60685e0438932c66" => :high_sierra
    sha256 "60ea4ce05f296dc1ffd595224eba11dabf13f7692ffb53289606241d80fc76fb" => :sierra
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
                          "--with-emacs-prefix=#{share}/emacs/site-lisp/#{name}",
                          "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
