class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.3/gsmartcontrol-1.1.3.tar.bz2"
  sha256 "b64f62cffa4430a90b6d06cd52ebadd5bcf39d548df581e67dfb275a673b12a9"

  bottle do
    sha256 "c1a64a3ff57b7ed92240bfdc20ad1330107cc28b9d2fc9ddfcf5665d7231cc71" => :high_sierra
    sha256 "f7f9eb0db8c802cdf829028476c74eec2ec12c0c322eed774cf8890ebe10aca8" => :sierra
    sha256 "dd26ca185000c056741ad62bf102808258ac4852553e47a42c60375db706a46c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "smartmontools"
  depends_on "gtkmm3"
  depends_on "pcre"

  needs :cxx11

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
