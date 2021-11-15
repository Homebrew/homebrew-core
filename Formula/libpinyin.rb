class Libpinyin < Formula
  desc "Library to deal with pinyin"
  homepage "https://github.com/libpinyin/libpinyin"
  url "https://github.com/libpinyin/libpinyin/archive/2.6.1.tar.gz"
  sha256 "936c756bf57205f064eb7731772289b2e9769ba5b52d6be957a17a9d3b4d5d0f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0ef181490605aaf65879895f82f5767b541f6ad2c5b82b69be4f769913c3625f"
    sha256 cellar: :any,                 arm64_big_sur:  "318f5f316d2d49d3c0cafac9a911e7e0b4c281e5112e523cab7c7ee9ece570ae"
    sha256 cellar: :any,                 monterey:       "a391e633e73d3cf2f10217b08afa4ebba6f6d77afab4d8a2a0bfb6f83d90f971"
    sha256 cellar: :any,                 big_sur:        "758fc82d1e5f0458f23e00cc3b9f38cf4b30099d7ecdef3d969fc40de334787b"
    sha256 cellar: :any,                 catalina:       "7f84e4aa3ca24a3c722a06aedc7a18a16cb188884e2c665c949dbe160506b8c6"
    sha256 cellar: :any,                 mojave:         "f2673713072b32704d2017f4643edc1071b49e8766659831287da96e0c29e783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abad6e2cc1bd2707aa4cce999da7d924ea075fe3cf6fdc39fa0352ee86288ce2"
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
    # Fix linker flags used in building/linking libzhuyin: https://github.com/libpinyin/libpinyin/pull/151
    inreplace "src/Makefile.am", "-exported_symbols_list=$(srcdir)", "-exported_symbols_list,$(srcdir)"

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
