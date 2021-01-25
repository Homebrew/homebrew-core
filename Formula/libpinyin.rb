class Libpinyin < Formula
  desc "Library to deal with pinyin"
  homepage "https://github.com/libpinyin/libpinyin"
  url "https://github.com/libpinyin/libpinyin/archive/2.6.0.tar.gz"
  sha256 "2b52f617a99567a8ace478ee82ccc62d1761e3d1db2f1e05ba05b416708c35d2"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "e4ffe7193d01eb5e040da9f4a9f8b53f214a989b0f07553cce636e31325032a2" => :big_sur
    sha256 "ccce070c15525539c1b1573e1ade80fc81a70007a08377698b30f0180384db59" => :arm64_big_sur
    sha256 "134f8fe1749c65e65c222f14dbd0d2b758e82df5dc5193d31e6fda2b43056773" => :catalina
    sha256 "b9a8e06f0534bb5e9c15f27be8d4bd78be2082e3ea241d2d3500c9357e5a786b" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnome-common" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "glib"

  # The language model file is independently maintained by the project owner.
  # To update this resource block, the URL can be found in data/Makefile.am.
  resource "model" do
    url "https://downloads.sourceforge.net/libpinyin/models/model19.text.tar.gz"
    sha256 "56422a4ee5966c2c809dd065692590ee8def934e52edbbe249b8488daaa1f50b"
  end

  def install
    resource("model").stage buildpath/"data"
    system "./autogen.sh", "--enable-libzhuyin=yes",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pinyin.h>

      int main()
      {
          pinyin_context_t * context = pinyin_init (LIBPINYIN_DATADIR, "");

          if (context == NULL)
              return 1;

          pinyin_instance_t * instance = pinyin_alloc_instance (context);

          if (instance == NULL)
              return 1;

          pinyin_free_instance (instance);

          pinyin_fini (context);

          return 0;
      }
    EOS
    glib = Formula["glib"]
    flags = %W[
      -I#{include}/libpinyin-#{version}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -L#{lib}
      -L#{glib.opt_lib}
      -DLIBPINYIN_DATADIR="#{lib}/libpinyin/data/"
      -lglib-2.0
      -lpinyin
    ]
    system ENV.cxx, "test.cc", "-o", "test", *flags
    touch "user.conf"
    system "./test"
  end
end
