class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_big_sur: "230fddcffeab41e3d3c674967866220707ebf723df71052c41066c45078f547a"
    sha256 cellar: :any, big_sur:       "8b5557ea3d590cbd62a6f9a39d57bc73c0a44f27006c92e78e5aa8b4fb36b482"
    sha256 cellar: :any, catalina:      "33ded09a74a39dfb922b0a91fc2116c9ed286b473d6233929c2fc2a8e6eff8f7"
    sha256 cellar: :any, mojave:        "fd2142f91f93b9aaf21f6396d5992a2574fd41cdd00aabb2d8ad1c8d8c839c40"
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

    on_macos do
      ENV.append "LDFLAGS", "-liconv"
    end

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
