class Libpinyin < Formula
  desc "Library to deal with pinyin"
  homepage "https://github.com/libpinyin/libpinyin"
  url "https://github.com/libpinyin/libpinyin/archive/refs/tags/2.10.3.tar.gz"
  sha256 "a49286721fb2b0234d86c095db9226246b0aa4a0bb6a885d0902da2743c56476"
  license "GPL-3.0-or-later"

  # Tags with a 90+ patch are unstable (e.g., the 2.9.91 tag is marked as
  # pre-release on GitHub) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de407b23ef3deebd69bdda4160591705884a7b45fcf63518867f7218534dce74"
    sha256 cellar: :any,                 arm64_sequoia: "73fe3debe8e55d78e4e2ba3fc01fa84aa97ef89dd60adf41596eadee37ddb040"
    sha256 cellar: :any,                 arm64_sonoma:  "b6ec348b937f4a2a1da925a160be7dcad08b458eae3a1fa30f965a54c294fe2e"
    sha256 cellar: :any,                 sonoma:        "c152806d01f00326521a8da08f1e4509d0b19a449e10f2dca16bbe2e08340164"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a06f3065cfd258fa3e25994e1067d57b2ee59f999f3441ad8b00174b198bf5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4bf5113220b57a9691995f825b0171c9bba1c63fd0aee0e9c6eb9c2f8023c44"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
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
