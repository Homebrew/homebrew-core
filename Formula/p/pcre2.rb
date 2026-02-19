class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.47/pcre2-10.47.tar.bz2"
  sha256 "47fe8c99461250d42f89e6e8fdaeba9da057855d06eb7fc08d9ca03fd08d7bc7"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "948b00bdaf75a842341f08a949ca3d414ae5333df2c305a7e371be31a2c30963"
    sha256 cellar: :any,                 arm64_sequoia: "bef2e718b92e5e819a51723157e60eceb76acc4efb0894a10c315cd36abca13c"
    sha256 cellar: :any,                 arm64_sonoma:  "f6d184fa59de4ca2f3115cb661f113c6c25ced2247b4e169dd99389c0d58be3f"
    sha256 cellar: :any,                 tahoe:         "7503247c5411d7a67b2d29ef5a7464a14f114c0953a541bb61bf668454fae667"
    sha256 cellar: :any,                 sequoia:       "167ef6d2b6337706884e23ee902cfc2ff8faeb455f2e07d23233e3061268867c"
    sha256 cellar: :any,                 sonoma:        "72691a0ed5b0ec4d21641ee33aa00fad05e6e8ddbfa417fe27f4cd26521ed24a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fb733022376752008209b8cd9235456eb11aab159114c562c2e845f9f4a34b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70d6e7a6d4257227d3b6c8e3b0bbcb244852eff6fc7a30fba6b6474316a4ea1d"
  end

  head do
    url "https://github.com/PCRE2Project/pcre2.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-pcre2-16
      --enable-pcre2-32
      --enable-pcre2grep-libz
      --enable-pcre2grep-libbz2
      --enable-jit
    ]

    args << "--enable-pcre2test-libedit" if OS.mac?

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
