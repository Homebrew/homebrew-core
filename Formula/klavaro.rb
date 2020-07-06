class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.10.tar.bz2"
  sha256 "25e1387aa1553447fa759f364e5930985cf8ca3f27b5f8f802d5e0d86c6edf4a"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 "fcdf087c22fed79c28c0c43aa8c82af9d631770040011b55c47c7c140d5200fa" => :catalina
    sha256 "0884d8ae7d2c1cbf535afda565b06b2ae27e675b2e91c2b403d229508dd337d0" => :mojave
    sha256 "4e34ed13b02cf0a6f2226a01f5b32a1ff3a59cd197ec52506ef5fc5299d45004" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    rm_rf include
  end

  test do
    system bin/"klavaro", "--help-gtk"
  end
end
