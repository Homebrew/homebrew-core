class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.10.tar.bz2"
  sha256 "25e1387aa1553447fa759f364e5930985cf8ca3f27b5f8f802d5e0d86c6edf4a"

  bottle do
    sha256 "118889b1341fa6f5f1c6b7ad157260f88f33d137705d1076f07de28a6f644cb5" => :catalina
    sha256 "2a106ecb579e6554e680ddb4499131cdef455fbf046c0b32a1e0edd8651bc8cf" => :mojave
    sha256 "65d11ee5c0da8b74a8b91a7f9d8da8e174d0bd11bbb8c2de2f53f6d0860342f9" => :high_sierra
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
