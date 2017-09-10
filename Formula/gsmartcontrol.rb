class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.0/gsmartcontrol-1.1.0.tar.bz2"
  sha256 "90c9ead852255f5e1a74a3ff6c265d1cbcba19ad2fc77059c60737c13a3cd2c8"

  bottle do
    sha256 "18bedc9f4a86e87ecffb2b849af5987de60d70e1fe7a8acdce8f44f2119ee5d7" => :sierra
    sha256 "4ada57cbcb5ad1d7dce8393b3c50bbec57a8bebe9e78c716ac3977eee2629b67" => :el_capitan
    sha256 "03855826f550c4a677c946fa713da68ea4591c31d43e87f3e2278aaf1b55338d" => :yosemite
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
