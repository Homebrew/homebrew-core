class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 10

  livecheck do
    url "https://rybczak.net/ncmpcpp/installation/"
    regex(/href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3ce6aad4d93abe434a6bf1e1eaaf4e3ea979a482531a78e97c6a288f5f1ae6ce"
    sha256 cellar: :any,                 arm64_monterey: "0d4527e8b01c0c2e8f322289466385b02dc69ef4b9e0ccf4983245967f00df36"
    sha256 cellar: :any,                 arm64_big_sur:  "72c8c434ea867d893d49e742ae8109492d65df25a672976e33bf7cd726621a1c"
    sha256 cellar: :any,                 ventura:        "5830429e3f76f324afc99b8a339e51328328ed7bed1e0ebcb78232067f785622"
    sha256 cellar: :any,                 monterey:       "d467809068fc47fbce693f0fc63f7c23d4c4c0dbe6c6460519ae7572dcd7d0a4"
    sha256 cellar: :any,                 big_sur:        "912ccbfdb455c217ebbc4a76bd0226b9c80cd82859dc8b74701755f1b32e0192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb8a046a754eecbcf5dbf9c3fe070a63072ae63925e9c86a3cafdefa37f68b5f"
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
