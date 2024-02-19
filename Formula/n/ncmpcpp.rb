class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 14

  livecheck do
    url "https://rybczak.net/ncmpcpp/installation/"
    regex(/href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ea3916369852777ebcf702726d96c2680aebe785ec4ce7194e0189bf37d63110"
    sha256 cellar: :any,                 arm64_ventura:  "d7a6d1c099af8e2b2ca77cdd6989b776ca0ed94286da01c4b8e0f328981f8e88"
    sha256 cellar: :any,                 arm64_monterey: "9b6508ed32d49f365f741d9d9bbc7d54dd1c8cdad2acee15b7f9ce7826517a74"
    sha256 cellar: :any,                 sonoma:         "f356219b0a86ac55ee3c6706aac0a9383b430f6de98af7e1fe55d24e8bf04e69"
    sha256 cellar: :any,                 ventura:        "bea0118bf1b94b69696e2b4d068b922a1485e9995a14a168ee18043267989b4e"
    sha256 cellar: :any,                 monterey:       "19ce924d62932e60bbd9d10b8d3d2ad8620802742fdf5a178b99e3b6e4a32d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c81e1846564d12174b2a9d428d8cc58ce88ef910050e88f20ae859d851dc70e"
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
  depends_on "icu4c"
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
