class Kawa < Formula
  desc "Programming language for Java (implementation of Scheme)"
  homepage "https://www.gnu.org/software/kawa/"
  url "https://ftpmirror.gnu.org/kawa/kawa-2.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/kawa/kawa-2.2.tar.gz"
  sha256 "c3e2cb5ae772e7441ac31484083bcee651de941bbfed5dbe4874964839b9ba32"

  bottle do
    cellar :any_skip_relocation
    sha256 "6835c16df5b606317d824e24fa77a6ebbcba2d84bf65f3e4c7651e78d19b265d" => :sierra
    sha256 "4597b613cb09de8c983842bb9a430165c3f573e1721759ee6522acd3b62fe957" => :el_capitan
    sha256 "e90e2696e371914074e8a23bf787f5f490cbdce83ec87d8ca00034c9dd541386" => :yosemite
  end

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
