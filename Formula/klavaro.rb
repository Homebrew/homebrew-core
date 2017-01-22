class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "http://klavaro.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.02.tar.bz2"
  sha256 "5f77730a8c1c8dfd4443ec8390c7226e3f82537df0882cd1222b140f0d0fcd6c"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"klavaro", "--help-gtk"
  end
end
