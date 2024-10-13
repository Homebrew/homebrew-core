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
    sha256 cellar: :any,                 arm64_sequoia:  "08bab8111030ef46cbd6c3914b805ab0253c0e8903220e51c3104ac15ba4c889"
    sha256 cellar: :any,                 arm64_sonoma:   "93f6df194768185e3a31b086804704a41fa7502925fd27ee0223f3d76a127d9e"
    sha256 cellar: :any,                 arm64_ventura:  "62ed5199739dcaae0ead97433ba897628981a6d3460a2718e4b41891c77842bc"
    sha256 cellar: :any,                 arm64_monterey: "9029eba7441fd7bf391a4b7f098d1459a2800b3d38abe6ad7d684b0d754d1376"
    sha256 cellar: :any,                 arm64_big_sur:  "0fb826732bff1c6e1b4925d289a7225f7aa8dbd2130f62592a7f9e7163e77799"
    sha256 cellar: :any,                 sonoma:         "5cfaa643ad861878a48ffcc399b4a90be2aac3e9be546d176b225840a401cd8f"
    sha256 cellar: :any,                 ventura:        "634410145976dea7c905671ced7fe0f38d6fdad9d1433d7c0e6338c1cea1138e"
    sha256 cellar: :any,                 monterey:       "aede5aed924b8237f69c86fd4a68d31f17d04dcf328548bb4872836803c560cf"
    sha256 cellar: :any,                 big_sur:        "93f521f571f01608a07acfa914a17ee9085d9787659bf46a15d36d96e6e26d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cd31415baad247bf8886eff8243b1e1b0fb8b068bce7ae9ec267e2fee3b3524"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  # macOS `ld64` does not like the `.la` files created during the build.
  # upstream issue report, https://github.com/libpinyin/libpinyin/issues/158
  depends_on "llvm" => :build if DevelopmentTools.clang_build_version >= 1400
  depends_on "pkg-config" => :build
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
      # Upstream uses -O2 but brew does not provide an ENV.O2 so manually set this
      ENV["HOMEBREW_OPTIMIZATION_LEVEL"] = "O2"
    end

    resource("model").stage buildpath/"data"
    system "./autogen.sh", "--enable-libzhuyin=yes", "--disable-silent-rules", *std_configure_args
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
