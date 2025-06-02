class Libpinyin < Formula
  desc "Library to deal with pinyin"
  homepage "https://github.com/libpinyin/libpinyin"
  url "https://github.com/libpinyin/libpinyin/archive/refs/tags/2.10.2.tar.gz"
  sha256 "8409bc81c8fce83f31649f7287e94cc71813947b1e767c544a782023ac2b5a22"
  license "GPL-3.0-or-later"

  # Tags with a 90+ patch are unstable (e.g., the 2.9.91 tag is marked as
  # pre-release on GitHub) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aaed14d5715f8e7729bc8d9cd92e3e8e4dd2dd9441e9ced1e0b96580bf00b54a"
    sha256 cellar: :any,                 arm64_sonoma:  "e04db469902c1b7e903fdb9175516108c839938f43f4a0e88ba6815c3aec9d5a"
    sha256 cellar: :any,                 arm64_ventura: "ce5ff005c6062a0fe25f847360e108005fe501781001a00639d293b998f6994c"
    sha256 cellar: :any,                 sonoma:        "ee86347d03773114f21f384cad57fb4bcb2b43cf0dedabab4ff351dbd5d95627"
    sha256 cellar: :any,                 ventura:       "b14da0e3d354815d87d73b7d23b80e04be3054dc4bc84851ded699141a79cf2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde0e982926df86e7021cdadfabaf61170ba028ecc02c96c4d36d0e160b6259b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8559ecb72bf0427461e62a367105bc470aff731f506e61e3816fffd8da9c6a06"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  # macOS `ld64` does not like the `.la` files created during the build.
  # upstream issue report, https://github.com/libpinyin/libpinyin/issues/158
  depends_on "lld" => :build if DevelopmentTools.clang_build_version >= 1400
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"

  on_macos do
    depends_on "berkeley-db"
    depends_on "gettext"
  end

  on_linux do
    # We use the older Berkeley DB as it is already an indirect dependency
    # (glib -> python@3.y -> berkeley-db@5) and gets linked by default
    depends_on "berkeley-db@5"
  end

  # The language model file is independently maintained by the project owner.
  # To update this resource block, the URL can be found in data/Makefile.am.
  resource "model" do
    url "https://downloads.sourceforge.net/libpinyin/models/model20.text.tar.gz"
    sha256 "59c68e89d43ff85f5a309489499cbcde282d2b04bd91888734884b7defcb1155"
  end

  def install
    # Workaround for Xcode 14 ld.
    if DevelopmentTools.clang_build_version >= 1400
      ENV.append_to_cflags "-fuse-ld=lld"
      # Work around superenv causing ld64.lld: error: -Os: number expected, but got 's'
      ENV.O3
    end

    resource("model").stage buildpath/"data"
    system "./autogen.sh", "--enable-libzhuyin=yes", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~CPP
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
    CPP

    flags = shell_output("pkgconf --cflags --libs libpinyin").chomp.split
    system ENV.cxx, "test.cc", "-o", "test", "-DLIBPINYIN_DATADIR=\"#{lib}/libpinyin/data/\"", *flags
    touch "user.conf"
    system "./test"
  end
end
