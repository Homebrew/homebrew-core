class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.3/gsmartcontrol-1.1.3.tar.bz2"
  sha256 "b64f62cffa4430a90b6d06cd52ebadd5bcf39d548df581e67dfb275a673b12a9"

  bottle do
    sha256 "c3fac414f6177d08cd1ac1cfedead1396b4ab6c1ea44a266851c0173b861c577" => :high_sierra
    sha256 "756f8fbdfaf5636b541749868e5dacce7e0d3e69ff1e43c693b35e9c1b9b1fd3" => :sierra
    sha256 "e18b4170555c8d1ab5e70c7e73817be81d064f9307372c0606e1c989b3eacffe" => :el_capitan
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
