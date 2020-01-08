class Mftrace < Formula
  desc "Trace TeX bitmap font to PFA, PFB, or TTF font"
  homepage "http://lilypond.org/mftrace/"
  url "http://lilypond.org/downloads/sources/mftrace/mftrace-1.2.19.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/mftrace-1.2.19.tar.gz"
  sha256 "778126f4220aa31fc91fa8baafd26aaf8be9c5e8fed5c0e92a61de04d32bbdb5"
  revision 2

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0b37a517fc1ca5227f3e67700fe40d01641ebe45da79f4acaeb9856b4d7db201" => :catalina
    sha256 "2a78bf8fc82f89a881f50f564d3ef1deefadccbee91c3eb9e47a213daeb54cf9" => :mojave
    sha256 "c5d1759a38176c1b8c237f5e9dcc116283012fab1d934664e02ba0f29a0fd2a5" => :high_sierra
    sha256 "17bd3d744d0d5092e48d06bce7452e0bd47884b3836561babede6ab9528cb1c6" => :sierra
  end

  head do
    url "https://github.com/hanwen/mftrace.git"
    depends_on "autoconf" => :build
  end

  depends_on "fontforge"
  depends_on "potrace"
  depends_on "python"
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
