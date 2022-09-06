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
    sha256 cellar: :any,                 arm64_monterey: "de85eb8214f729e96ad633c04df55a86f4d14cb8d46cbbffc5bf2598af6c424c"
    sha256 cellar: :any,                 arm64_big_sur:  "1970a1df6daea6b43e15ce4786f9510247143977be9fe6627eedaaf66983c6d1"
    sha256 cellar: :any,                 monterey:       "8b05d94744a7d7cb1458c20256256171e521a65af48759ca7b61472982dd157e"
    sha256 cellar: :any,                 big_sur:        "c0f19a75fa5b6a131867182fe85f677e008b461d58657e2aef53e5635fbcceb7"
    sha256 cellar: :any,                 catalina:       "3d288b8a402be8bc838fe0647f04fc656011acaa6eb9fe63700e8c905ee8f9b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d6a1a5633de6ab5a5f664ac3792918c694b17b95f90a59f6486a87779ab6236"
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
