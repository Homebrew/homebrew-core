class Mftrace < Formula
  desc "Trace TeX bitmap font to PFA, PFB, or TTF font"
  homepage "https://lilypond.org/mftrace/"
  url "https://lilypond.org/downloads/sources/mftrace/mftrace-1.2.19.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/mftrace-1.2.19.tar.gz"
  sha256 "778126f4220aa31fc91fa8baafd26aaf8be9c5e8fed5c0e92a61de04d32bbdb5"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "882a66ccd5a29f67e0fcefb320fd2e271b367c84c48710a4d979940ad8abc4a4" => :catalina
    sha256 "216a869a5dc6455c8853f7965993eb86d4c310dad2d2e8b343690de91d5d9621" => :mojave
    sha256 "487f07e5aec705b5503b97654dbafce5c4c01c94d733d0c51d241b595bc801cc" => :high_sierra
  end

  head do
    url "https://github.com/hanwen/mftrace.git"
    depends_on "autoconf" => :build
  end

  depends_on "fontforge"
  depends_on "potrace"
  depends_on "python@3.8"
  depends_on "t1utils"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mftrace", "--version"
  end
end
