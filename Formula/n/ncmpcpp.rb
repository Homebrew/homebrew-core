class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 12

  livecheck do
    url "https://rybczak.net/ncmpcpp/installation/"
    regex(/href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7e108edcc6bb7560e2fd59a3ff84a2c23332713a70ee87a7c4bfe73dca3a9dc8"
    sha256 cellar: :any,                 arm64_monterey: "236d1c723a22ca5cc26ec73385970210f049c00914c28d46e3f5b07e383dfaa6"
    sha256 cellar: :any,                 arm64_big_sur:  "0f26de5f9f6b05b5c26244521814714a7391476340096d1884ad986d3b4419ac"
    sha256 cellar: :any,                 ventura:        "1af2074eba35f2db1b4ff7727e78e88ad883858cc0c5697ff4b8c52e79dfb0c9"
    sha256 cellar: :any,                 monterey:       "56daaa3e0b881c2407e5d072f60a00d84ab2547d540bc9b5799b9cf4311e8c7d"
    sha256 cellar: :any,                 big_sur:        "28e694da13a4c9309dd455be2eca2c199b134153fed11b0aac7be7e48209b662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "525e7566cf49eca2980c22ff9da6593fa323a6f8e8adc4421dcfcbd7b7256ccb"
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
