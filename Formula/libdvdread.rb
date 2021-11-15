class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  license "GPL-2.0"

  stable do
    url "https://download.videolan.org/pub/videolan/libdvdread/6.1.2/libdvdread-6.1.2.tar.bz2"
    sha256 "cc190f553758ced7571859e301f802cb4821f164d02bfacfd320c14a4e0da763"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "052f0ed3e5b717a51f0fad220b4db2e11790a6e2b4cd76c641d116f82d9705a2"
    sha256 cellar: :any,                 arm64_big_sur:  "d3e2a48d9d4f4e1e39a68645094be1536cae40fa0c2c6cff7907ec408d3c4439"
    sha256 cellar: :any,                 monterey:       "7dca89986d2f00293af0500ff31e277caf173b12c7cb102ac5c498fbe594bf3a"
    sha256 cellar: :any,                 big_sur:        "7d0a516f36d885df836072671f8885218a1684fbab69dad9761629ed87483640"
    sha256 cellar: :any,                 catalina:       "08b72c46e9022170d991a626a84a073bd988f99db12bc145494306fc28f33d73"
    sha256 cellar: :any,                 mojave:         "ddd7ecdfc66b0b12b4804550aaab8939f2bbd30bcd753ac9006f3db079589515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40dc2e4bc0128e1468141d4b3805a4c135576101ffdcf8872c5787291b15bdd5"
  end

  head do
    url "https://code.videolan.org/videolan/libdvdread.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libdvdcss"

  def install
    ENV.append "CFLAGS", "-DHAVE_DVDCSS_DVDCSS_H"
    ENV.append "LDFLAGS", "-ldvdcss"

    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
