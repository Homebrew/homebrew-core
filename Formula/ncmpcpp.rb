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
    sha256 cellar: :any,                 arm64_ventura:  "f88f7864390df75a1f92c4255bc09f32022e9ee2cd33fa25164f4d1d6da148ed"
    sha256 cellar: :any,                 arm64_monterey: "27b42c6308ac926429db71b2f0a1a1c4db6fe74bb78721f1fe12b08fb72cc0c2"
    sha256 cellar: :any,                 arm64_big_sur:  "9659fcfd6e732577cca4a6071379b0c08dc67d1d679f4432e4480ef5c12a7f81"
    sha256 cellar: :any,                 ventura:        "a225b14589825386dd864df4902d425eab7d39d20eec70bea91eb8f911ea9289"
    sha256 cellar: :any,                 monterey:       "43ed5afc1d2f9558f8ee1a0d8332eacdabec067671f38780793a24a88c854dc7"
    sha256 cellar: :any,                 big_sur:        "e52ca27beb76d8d78da24d13778f5c79383570d325e7b37d8de4f45cbb46fb42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55e66b40f9b10b70e9426f455a213aa88ebc5b442dbee2f0ee43182674455fc5"
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
