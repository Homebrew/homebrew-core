class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.09.tar.bz2"
  sha256 "9983e501563a4d05e429700a2bd5bb078ac43b2f0d4014864e3cac42e0a1f589"
  revision 1

  bottle do
    sha256 "2ba4e6a15b27a690ff12f07439e998a6b861c2abc888d6dbfb5b7f8e38294137" => :catalina
    sha256 "be732fb8cb7241aaa250e040c9eee11e27c36023e11993b447746c0fefbeb302" => :mojave
    sha256 "633f7968ade19e794298386ca5939eee7c3800d5a1c9123c7ebc435ed32f6bb2" => :high_sierra
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
