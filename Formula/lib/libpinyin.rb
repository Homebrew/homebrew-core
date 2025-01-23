class Libpinyin < Formula
  desc "Library to deal with pinyin"
  homepage "https://github.com/libpinyin/libpinyin"
  url "https://github.com/libpinyin/libpinyin/archive/refs/tags/2.8.1.tar.gz"
  sha256 "42c4f899f71fc26bcc57bb1e2a9309c2733212bb241a0008ba3c9b5ebd951443"
  license "GPL-3.0-or-later"

  # Tags with a 90+ patch are unstable (e.g., the 2.9.91 tag is marked as
  # pre-release on GitHub) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "a97c5a5bbaf53f34f607ea8bfa3a8af862cfc7f4aefde3712bf1f6add88fbc62"
    sha256 cellar: :any,                 arm64_sonoma:  "0364ce14c457724bb5a3f7bcea2f491977a36bb9b30afeb8b0aa19adc32b7ecd"
    sha256 cellar: :any,                 arm64_ventura: "119fc40f85b091ede91132993a2cd2b7ea7a5c27a6572e64b23baf778ccaa849"
    sha256 cellar: :any,                 sonoma:        "6f152f77521d8bca325af78a7a15f755576ef6d0d9d0e7b665f9c5193374c10d"
    sha256 cellar: :any,                 ventura:       "a5cb0c9b78c3ed3a0b8ebc23020016aff851bf7154955b0dabbca2728ad872c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92a7a7d3ef5801eb1be45427de6ad5b333414fab65663bb170d823b44bc5fed2"
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
    url "https://downloads.sourceforge.net/libpinyin/models/model19.text.tar.gz"
    sha256 "56422a4ee5966c2c809dd065692590ee8def934e52edbbe249b8488daaa1f50b"
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
