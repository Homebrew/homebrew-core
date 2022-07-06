class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 7

  livecheck do
    url "https://rybczak.net/ncmpcpp/installation/"
    regex(/href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "465d074e6043ca7b5e43dcd61cf2728a8abc84ffaf4a6a7d55be3abae74010e3"
    sha256 cellar: :any,                 arm64_big_sur:  "31d95d08a6cdb5d09bb5a25fb8bff69d4b3c6c838806e4014e30e94661b8796e"
    sha256 cellar: :any,                 monterey:       "bc4675474e3c06ee42c872fe03def44b20aafd84d626c2ea0c7d35d3a5e8efe7"
    sha256 cellar: :any,                 big_sur:        "e69ed6b10304a4c282226632ad807402b7417465db90ab22cb33a75572e6db69"
    sha256 cellar: :any,                 catalina:       "8b5bb474fde119b3a0a87d64fa0df18c859ac0d409b58df341f9b7ba511f218c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81e4cb9920dc5bf43d081b2c58a1f011c95f757fbb0666b52c0a27c958788bd9"
  end

  head do
    url "https://github.com/ncmpcpp/ncmpcpp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "fftw"
  depends_on "libmpdclient"
  depends_on "ncurses"
  depends_on "readline"
  depends_on "taglib"

  uses_from_macos "curl"

  def install
    ENV.cxx11

    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    ENV.append "BOOST_LIB_SUFFIX", "-mt"
    ENV.append "CXXFLAGS", "-D_XOPEN_SOURCE_EXTENDED"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-clock
      --enable-outputs
      --enable-unicode
      --enable-visualizer
      --with-curl
      --with-taglib
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    ENV.delete("LC_CTYPE")
    assert_match version.to_s, shell_output("#{bin}/ncmpcpp --version")
  end
end
