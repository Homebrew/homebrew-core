class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 17

  livecheck do
    url "https://rybczak.net/ncmpcpp/installation/"
    regex(/href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "697505ba19ceb282b1f3d6a7ee9dca9850e5aacbdd555c06726360b7b3e34807"
    sha256 cellar: :any,                 arm64_ventura:  "fddd6f8b41e1ec3c6e3b8723fb6bd02232f7999eecb104cadfd1f5342d86253e"
    sha256 cellar: :any,                 arm64_monterey: "54065a4855826eeac1e1fb87760e72bc7a2b243c41657270a7115bad5714d175"
    sha256 cellar: :any,                 sonoma:         "fbfb67620edcc0c907762dcd77002530c3b43130856c7a90daa0ab26f3cd0faf"
    sha256 cellar: :any,                 ventura:        "2be85dace5f5c11ba98510972e23321d6cbd4b8dfdd960f50f95703b0e658910"
    sha256 cellar: :any,                 monterey:       "493f9684b942ec5112ed4b4f61112265eb58a49acfd0e5761a4c465e179c07ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "255f731bf0430d37240b3ea8b095eb06c39e7240f797f017134217b420300db5"
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
