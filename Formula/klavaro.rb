class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.05.tar.bz2"
  sha256 "fe82c6c108a3c40ab97902a8874c6d10fd891b4ff1accce757e5cba0e361dd10"
  revision 1

  bottle do
    sha256 "4d33d082a523b398afd28e9d22d5210b2b46a8ce436785363ecfe4047f7b49fc" => :mojave
    sha256 "4ee0e35412caf80c0f9edf92153436919e6e673d696955a090a57d94565732b8" => :high_sierra
    sha256 "b0b978b9d20523a2b36eca2f2da5ddec4f979908e4714ffcf7f2bb2ea6927592" => :sierra
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
