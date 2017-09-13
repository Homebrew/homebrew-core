class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.0/gsmartcontrol-1.1.0.tar.bz2"
  sha256 "90c9ead852255f5e1a74a3ff6c265d1cbcba19ad2fc77059c60737c13a3cd2c8"

  bottle do
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
