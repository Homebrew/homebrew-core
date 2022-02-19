class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url "https://rybczak.net/ncmpcpp/installation/"
    regex(/href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ef3e0031e1ba427a6315fc756abe42ae760f624892663810477f26536540d995"
    sha256 cellar: :any,                 arm64_big_sur:  "8594f9595771cefc90a86421ed5b03b7262aa7b91162a3b8cf203ede3f21eeac"
    sha256 cellar: :any,                 monterey:       "a588974bca0b183dd228ea9515364beb12379b5671b406dddda48d7bda03e2b4"
    sha256 cellar: :any,                 big_sur:        "7dea7f462feb5301877a68b486c116c3f864264df71e03f3aa2d81b53061f09c"
    sha256 cellar: :any,                 catalina:       "da8e1209c47e80748f1b9bb65b4d5e2a8837de24d15de421f9782d76dac8e960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a513079cfcdc2f9ecfd105a0706691c505d3456757d25e27e4a602c6aaa6e44e"
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
