class Madplay < Formula
  desc "MPEG Audio Decoder"
  homepage "https://www.underbit.com/products/mad/"
  url "https://downloads.sourceforge.net/project/mad/madplay/0.15.2b/madplay-0.15.2b.tar.gz"
  sha256 "5a79c7516ff7560dffc6a14399a389432bc619c905b13d3b73da22fa65acede0"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/madplay[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "12c5f62bc659cbae5db709292b63edfbd9fccd3950e2b7eb1fda7bc39f92d01a"
    sha256 arm64_monterey: "6b0d3f661abe526d4cc4437bea68abe667f6faa9cff54d0e3a0670c0e54d4b4d"
    sha256 arm64_big_sur:  "2407e2250bbd71166947df1e754d5fd39b8bfbb30deeec6d191349495c9ee2a2"
    sha256 ventura:        "96cf920da6b41481fa2054ed1e8bb33e655e7a1b1a21a9af5875b9bfdfb6eb68"
    sha256 monterey:       "caacb11e058d2a15d13268f7e1b9b6ecbf76e92e64410a23eb32cda5bf94eda8"
    sha256 big_sur:        "cc587c330d6005c039fdd974da44ffa3da8e649337912c41300fe095ebc52b6d"
    sha256 catalina:       "b2a019e680f79bcd45a0c194439256d3211256449ad37378da25fb9376f1463e"
    sha256 x86_64_linux:   "c03953ba98444a1e710f25411e169b7a4f586c131d820ec63b19fceb36efc937"
  end

  depends_on "libid3tag"
  depends_on "mad"

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f6c5992c/madplay/patch-audio_carbon.c"
    sha256 "380e1a5ee3357fef46baa9ba442705433e044ae9e37eece52c5146f56da75647"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --build=x86_64
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/madplay", "--version"
  end
end
