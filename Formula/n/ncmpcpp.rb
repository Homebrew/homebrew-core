class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 15

  livecheck do
    url "https://rybczak.net/ncmpcpp/installation/"
    regex(/href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c34594758c5354c3262c9abb962b52798ddb5f29120576dba999dfd52ccd9e8f"
    sha256 cellar: :any,                 arm64_ventura:  "24e22e342621454e72791e81cd98b37bf16a0400c57a6f8fca4d4165624762e0"
    sha256 cellar: :any,                 arm64_monterey: "e54d5b84632d9ce12deafd47b50a5c2a1faec790082e094b26f45a9844b73d81"
    sha256 cellar: :any,                 sonoma:         "71dbad3f7d95622b1a5125730db8976b09bedb3939b36a352437837443256df9"
    sha256 cellar: :any,                 ventura:        "e678e10694dfafed2be4c4904925918e4b2c9f68121d8777e9b6653a01ae61d6"
    sha256 cellar: :any,                 monterey:       "302668e97b84cb0c9181bd8bd7e1df38e8bb27d8dd675d992a09b8f8f36925b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78257ff21b49cea4d90a6c3f965bc15426571430328e76415cccbc9b35f27d9f"
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
