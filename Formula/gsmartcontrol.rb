class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.1/gsmartcontrol-1.1.1.tar.bz2"
  sha256 "2e39ad330829ae93824732f1b663303ac9ea1223f703901fae28549a3b2d7518"

  bottle do
    sha256 "6f3f66e6f88e47c88c27e6729e95ae2e6041d5940ebbc1cbfe8a1904ec095ac9" => :high_sierra
    sha256 "0953506a9121a18b47c18db21feded67b70a09fa610f0522f7da2b4596f199db" => :sierra
    sha256 "d4d74dbd377d384216578d93ef26b75409eb112874d9b517a44c4bdf9eb10be1" => :el_capitan
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
