class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  license "BSD-3-Clause"

  # Remove `stable` block when patch is no longer needed
  stable do
    url "https://github.com/PhilipHazel/pcre2/releases/download/pcre2-10.38/pcre2-10.38.tar.bz2"
    sha256 "7d95aa7c8a7b0749bf03c4bd73626ab61dece7e3986b5a57f5ec39eebef6b07c"

    # fix incorrect detection of alternatives in first character search with JIT
    # remove in the next release
    patch do
      url "https://github.com/PhilipHazel/pcre2/commit/51ec2c9893e7dac762b70033b85f55801b01176c.patch?full_index=1"
      sha256 "0e91049d9d2afaff3169ddf8b0d95a9cd968793f2875af8064e0ab572c594007"
    end
  end

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "398a435ca747d30a60fce3a4df23a60925cddd997862b8225a7a3123e2209abd"
    sha256 cellar: :any,                 big_sur:       "c2f04108058a5cf4e9ad6ed127ea2b1195be6e13015241260683466cd49739d9"
    sha256 cellar: :any,                 catalina:      "1f81c9f906a96b87c922e4901e7f9f0057b259b82974737194f14f767bf437b0"
    sha256 cellar: :any,                 mojave:        "7eec2912f8a8248933a2c595185c4245b08f32f18b3a1a9dc84838a274aac16e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "502a9b9672c23b60b2a98db567171df17daf7851f8505f933c49b96699c3f64d"
  end

  head do
    url "https://github.com/PhilipHazel/pcre2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-pcre2-16
      --enable-pcre2-32
      --enable-pcre2grep-libz
      --enable-pcre2grep-libbz2
    ]

    # JIT not currently supported for Apple Silicon
    args << "--enable-jit" unless Hardware::CPU.arm?

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
