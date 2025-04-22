class Libpinyin < Formula
  desc "Library to deal with pinyin"
  homepage "https://github.com/libpinyin/libpinyin"
  url "https://github.com/libpinyin/libpinyin/archive/refs/tags/2.10.1.tar.gz"
  sha256 "f7444b0cedeb1e6011e08aa503e1e1513df11b60cddc7ed9693e630675d8fd87"
  license "GPL-3.0-or-later"

  # Tags with a 90+ patch are unstable (e.g., the 2.9.91 tag is marked as
  # pre-release on GitHub) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b3a7f8f3c78acae8c2688018a778d8bd1f87f41e492380acc83572b727a72fc2"
    sha256 cellar: :any,                 arm64_sonoma:  "aacf0504d2ef686d7f2be9243b2d7806e5d4e296a0d8281fb39abf052a237ccb"
    sha256 cellar: :any,                 arm64_ventura: "538b68fef893238e2dac6bc79011a2e2b306b76369b7cc0d2fadfcd835b3852e"
    sha256 cellar: :any,                 sonoma:        "23eb8e8f59debecba46d2d98403ba5b5bbad91ec69a2dd2a813cf22e4d970f61"
    sha256 cellar: :any,                 ventura:       "158dc73fed2ccda3e8d04fbe4cae6e0aff470d0ee3a5aaedf4d60314f974d9f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "230456760164843688e08ab606754c64e2bbb0c02e483fde8c7063e5088d9ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84a37f05541a6b55433a2ca832b45d746eaf91f7be103f1455f3fe51de9457df"
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
