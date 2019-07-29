class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.3/gsmartcontrol-1.1.3.tar.bz2"
  sha256 "b64f62cffa4430a90b6d06cd52ebadd5bcf39d548df581e67dfb275a673b12a9"
  revision 2

  bottle do
    sha256 "c0813f12d106a9440f82a3086fc750f313b2ef9ba38f2c61c561e726a239dbb9" => :mojave
    sha256 "11590c5d12f15d6e219c19c735f547fa138f643095dea94f1261decd4da6f8f3" => :high_sierra
    sha256 "aaf430dfa25548fbfbfe3bc94d00ce042ba5cd0d6bd7703809945006b1293fd7" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gtkmm3"
  depends_on "pcre"
  depends_on "smartmontools"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/gsmartcontrol", "--version"
  end
end
