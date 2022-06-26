class Libquvi < Formula
  desc "C library to parse flash media stream properties"
  homepage "https://quvi.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quvi/0.4/libquvi/libquvi-0.4.1.tar.bz2"
  sha256 "f5a2fb0571634483e8a957910f44e739f5a72eb9a1900bd10b453c49b8d5f49d"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/libquvi[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "c7334e914191fed570ebfb0c19f3d99c2d6558d9e585f6c7618507e8fa768bf4"
    sha256 arm64_big_sur:  "167718e2a3981fdbfa9b34cddc3c94ed4e0c80f4cbe82749535cd7b7c644d9a5"
    sha256 monterey:       "f7c71a0bd940fef6b1334b4fe4f3f8022cffb10adffc64a5499b6ca20b420026"
    sha256 big_sur:        "bcabb1b6f7812088c7dce8c919e1200ebc8f726ada4e5dadbf813ae20ec35835"
    sha256 catalina:       "6f98f88d5f98ef09c1aee13b24e89be731c79170b3bce5af1617a5309eade725"
    sha256 mojave:         "4916926b6bc9b2180ec1cf06bb24bc76eb9d342c748b4e36ddc65ffad1933cbd"
    sha256 high_sierra:    "bb5a4201afd814e87ee496b8cefbcf126f0245d7b3c600039e71e7b355115bf7"
    sha256 sierra:         "9968d412860717f837082f0e9d225b741d8430a99a3d1c4e12b7a1cdc95cd456"
    sha256 el_capitan:     "d91506a098fa564598b4aecbad97a2fa30728fafd8ad82bf8c4ff4bedb8d6c0a"
    sha256 x86_64_linux:   "86842f87a749f377843293787a9ce31911d10715e08e783cebe404d8ecd64e21"
  end

  depends_on "pkg-config" => :build
  depends_on "lua@5.1"

  uses_from_macos "curl"

  resource "scripts" do
    url "https://downloads.sourceforge.net/project/quvi/0.4/libquvi-scripts/libquvi-scripts-0.4.14.tar.xz"
    sha256 "b8d17d53895685031cd271cf23e33b545ad38cad1c3bddcf7784571382674c65"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
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
