class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "http://klavaro.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.02.tar.bz2"
  sha256 "5f77730a8c1c8dfd4443ec8390c7226e3f82537df0882cd1222b140f0d0fcd6c"

  bottle do
    sha256 "d2b2b39f035d969207cf6fb20577247771862c2c8f6a35ed280a5e95cd159e64" => :sierra
    sha256 "43835be86f96388d899af872ebc780441edb6b416c0d6b4e768c6a7e4221410e" => :el_capitan
    sha256 "d9971fbbd61aaf76298a9ec1046e88ca71064dfbb4f1c5be9372be9899ed2331" => :yosemite
  end

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
