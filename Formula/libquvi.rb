class Libquvi < Formula
  desc "C library to parse flash media stream properties"
  homepage "https://quvi.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quvi/0.4/libquvi/libquvi-0.4.1.tar.bz2"
  sha256 "f5a2fb0571634483e8a957910f44e739f5a72eb9a1900bd10b453c49b8d5f49d"
  revision 2

  bottle do
    sha256 "6f98f88d5f98ef09c1aee13b24e89be731c79170b3bce5af1617a5309eade725" => :catalina
    sha256 "4916926b6bc9b2180ec1cf06bb24bc76eb9d342c748b4e36ddc65ffad1933cbd" => :mojave
    sha256 "bb5a4201afd814e87ee496b8cefbcf126f0245d7b3c600039e71e7b355115bf7" => :high_sierra
    sha256 "9968d412860717f837082f0e9d225b741d8430a99a3d1c4e12b7a1cdc95cd456" => :sierra
    sha256 "d91506a098fa564598b4aecbad97a2fa30728fafd8ad82bf8c4ff4bedb8d6c0a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "lua@5.1"

  resource "scripts" do
    url "https://downloads.sourceforge.net/project/quvi/0.4/libquvi-scripts/libquvi-scripts-0.4.14.tar.xz"
    sha256 "b8d17d53895685031cd271cf23e33b545ad38cad1c3bddcf7784571382674c65"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["lua@5.1"].opt_libexec/"lib/pkgconfig"

    scripts = prefix/"libquvi-scripts"
    resource("scripts").stage do
      system "./configure", "--prefix=#{scripts}", "--with-nsfw"
      system "make", "install"
    end
    ENV.append_path "PKG_CONFIG_PATH", "#{scripts}/lib/pkgconfig"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
