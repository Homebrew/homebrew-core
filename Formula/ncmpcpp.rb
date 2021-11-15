class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "589a36dfb83da7b7093605e58cdf6a9ae6f58e8bc915fc84a937742b17aafad6"
    sha256 cellar: :any,                 monterey:      "45398850343c1d9b60fba96b519b7726e48d68bbbed0fb3681362e48fe542ce5"
    sha256 cellar: :any,                 big_sur:       "94f81334cde20719c43ff2e31cd89b89fe05b79e072f91e9ad5a9e8b104e7453"
    sha256 cellar: :any,                 catalina:      "491b03399a3f52b0ae8bd5ffd4ccbe34bff8565f1a5898d60c0a6c04e1bc43db"
    sha256 cellar: :any,                 mojave:        "228570b600da1e6001294be6761a84cf93f373a6d32aadbe38c7f239158835cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566109600ff2e4cf3988ba0031501c0f917ee9b9dd2d69f30a100f3016fc3c98"
  end

  head do
    url "https://github.com/ncmpcpp/ncmpcpp.git"

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
