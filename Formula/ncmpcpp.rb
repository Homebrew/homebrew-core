class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 9

  livecheck do
    url "https://rybczak.net/ncmpcpp/installation/"
    regex(/href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e788a047aa552285d5a98f617b4fa4e212797ebae6bf25e9264af088d04627ff"
    sha256 cellar: :any,                 arm64_monterey: "45d066da30e3dcce5a6345c67acbe07c1e3590c346046c9951bbdaa98eb2da00"
    sha256 cellar: :any,                 arm64_big_sur:  "a8389eb3a5385c9cfb1a2db767444c510e937f1b1a0e8331c208b1b0c5ffa8f3"
    sha256 cellar: :any,                 ventura:        "7ed7606a3d2ef188c7475070b99444e31e7750e018d531e847d91d90eee39cd9"
    sha256 cellar: :any,                 monterey:       "d8ec679506b89515a490c9687900a4f766284f1d9d6271ed7f392b7fe59afe37"
    sha256 cellar: :any,                 big_sur:        "3ce289778a9180462a2132c9bb78e3ef03acbc72b30fbec0fee308e136b5f0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5fc4f6550cf266e7da9ef7f5d1c1230c5c5729ca2def0d1a2e9f921ed653145"
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
