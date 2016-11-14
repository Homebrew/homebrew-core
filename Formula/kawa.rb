class Kawa < Formula
  desc "Programming language for Java (implementation of Scheme)"
  homepage "https://www.gnu.org/software/kawa/"
  url "https://ftpmirror.gnu.org/kawa/kawa-2.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/kawa/kawa-2.2.tar.gz"
  sha256 "c3e2cb5ae772e7441ac31484083bcee651de941bbfed5dbe4874964839b9ba32"

  depends_on :java

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    inreplace bin/"kawa",
      'while test -L "$thisfile"; do thisfile=$(readlink -f "$thisfile"); done',
      "thisfile=#{pkgshare}/bin/kawa"
  end

  test do
    system bin/"kawa", "--help"
  end
end
