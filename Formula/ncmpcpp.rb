class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 8

  livecheck do
    url "https://rybczak.net/ncmpcpp/installation/"
    regex(/href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "76f18301d32737baac84267995a24de92092dc76c60327c479c7a0f6dd84139b"
    sha256 cellar: :any,                 arm64_monterey: "cf2eca5f6cd5e691356f38ac0c5a8340b15e327d40ed716f0500baac4f7137b6"
    sha256 cellar: :any,                 arm64_big_sur:  "eced36d7c545a790542a896f7513b76167cdc0e61f8cce67573fb73154968ee6"
    sha256 cellar: :any,                 ventura:        "35b29ff5a268f63e9b72b2a390d736819539aa1536db14300413f39e4667f706"
    sha256 cellar: :any,                 monterey:       "afd09c2d5c806b93818042ca072c60a27d07819168fe31169c90689937002460"
    sha256 cellar: :any,                 big_sur:        "808b5a7a5a8a3b5af8e801e7c3220b56c034e14dc7d21469ffd071ba56d5d1c9"
    sha256 cellar: :any,                 catalina:       "055ce811b2df28549105dad74e5813ca160a443593b5ae2d043255b53d22b26c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aab89e6b1232657954e27f6e6623d7220d22c541bad3a6fcf05047a613b06c9"
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
