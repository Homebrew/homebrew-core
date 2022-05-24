class Libwps < Formula
  desc "Library to import files in MS Works format"
  homepage "https://libwps.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libwps/libwps/libwps-0.4.12/libwps-0.4.12.tar.xz"
  sha256 "e21afb52a06d03b774c5a8c72679687ab64891b91ce0c3bdf2d3e97231534edb"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    regex(%r{url=.*?/libwps(?:/|[._-])v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba873b5642db93a461f0f7f98d3504373b21a1906fc5641fea0508ed363bd879"
    sha256 cellar: :any,                 arm64_big_sur:  "0259e5d1fa798cec14c2680bbcf4ffa4791f2089840e9f27951900066f3f54bd"
    sha256 cellar: :any,                 monterey:       "761c1217f5a73534b8646eb87b308a21e1227c6a53e7ebad713d9240e0fde9c7"
    sha256 cellar: :any,                 big_sur:        "b90de41ccfbd2b12fa25c90985a9a526f42f38ffba22839583d8d8dca7680f57"
    sha256 cellar: :any,                 catalina:       "df168fef776884800b6e739e914ca328b2ed2011fb2f7c650a95ffb410669ff9"
    sha256 cellar: :any,                 mojave:         "6858e4fc67b746fa2f392c717eab3abf2af4826e7499489b4da45d98b9539b24"
    sha256 cellar: :any,                 high_sierra:    "cfba7b4a80156e0783277ea263ee303ecc2194b1a1147493e9b8e6ccafb3885d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6335afb0f28ca47b7a358bfe3a03857dd0b3ae940177ea9e8249f810a415b71"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"
  depends_on "libwpd"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          # Installing Doxygen docs trips up make install
                          "--prefix=#{prefix}", "--without-docs"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libwps/libwps.h>
      int main() {
        return libwps::WPS_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                  "-lrevenge-0.0",
                  "-I#{Formula["librevenge"].include}/librevenge-0.0",
                  "-L#{Formula["librevenge"].lib}",
                  "-lwpd-0.10",
                  "-I#{Formula["libwpd"].include}/libwpd-0.10",
                  "-L#{Formula["libwpd"].lib}",
                  "-lwps-0.4", "-I#{include}/libwps-0.4", "-L#{lib}"
    system "./test"
  end
end
