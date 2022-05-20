class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 5

  livecheck do
    url "https://rybczak.net/ncmpcpp/installation/"
    regex(/href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "92de9705b21cf154f6d1e2994452f5b7b1c7855f3fd6aa8c7a8d54108c37bb74"
    sha256 cellar: :any,                 arm64_big_sur:  "22ddf121680ee964577943839587ea51c751bfd01bba2bb5dcb50bd6775e7d87"
    sha256 cellar: :any,                 monterey:       "f4d20158915c29b5f081030bbe6537070aac7bc266f1138a55c8a8686ee84c68"
    sha256 cellar: :any,                 big_sur:        "c2978f45b0e739eb0a7d2f7c4bb82000fc653ac6068d3c55cd9bd9f2befa9628"
    sha256 cellar: :any,                 catalina:       "ba0f942ce81f8eb4e1b507d0f2f65b2248368207f694350c3791b74856bd60fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f48e2d81c7d66b7e345cb96f34014abe94453059f70a64aa9773f963d3e70775"
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
