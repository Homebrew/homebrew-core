class Libquvi < Formula
  desc "C library to parse flash media stream properties"
  homepage "https://quvi.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quvi/0.9/libquvi/libquvi-0.9.4.tar.xz"
  sha256 "2d3fe28954a68ed97587e7b920ada5095c450105e993ceade85606dadf9a81b2"

  bottle do
    sha256 "bb5a4201afd814e87ee496b8cefbcf126f0245d7b3c600039e71e7b355115bf7" => :high_sierra
    sha256 "9968d412860717f837082f0e9d225b741d8430a99a3d1c4e12b7a1cdc95cd456" => :sierra
    sha256 "d91506a098fa564598b4aecbad97a2fa30728fafd8ad82bf8c4ff4bedb8d6c0a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgcrypt"
  depends_on "libproxy"
  depends_on "lua@5.1"

  resource "scripts" do
    url "https://downloads.sourceforge.net/project/quvi/0.9/libquvi-scripts/libquvi-scripts-0.9.20131130.tar.xz"
    sha256 "17f21f9fac10cf60af2741f2c86a8ffd8007aa334d1eb78ff6ece130cb3777e3"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["lua@5.1"].opt_libexec/"lib/pkgconfig"

    scripts = prefix/"libquvi-scripts"
    resource("scripts").stage do
      system "./configure", "--prefix=#{scripts}", "--with-nsfw"
      system "make", "install"
    end
    ENV.append_path "PKG_CONFIG_PATH", "#{scripts}/lib/pkgconfig"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
