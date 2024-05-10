class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 16

  livecheck do
    url "https://rybczak.net/ncmpcpp/installation/"
    regex(/href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a424f530e6d711ad32ae26deb59c78ab85b7bf16b4dbd8c2d93248e50d97154a"
    sha256 cellar: :any,                 arm64_ventura:  "7aac9da7d6accfb8549cbfa4c82054366b93ceb25a57830d565b3d56d8cb3e03"
    sha256 cellar: :any,                 arm64_monterey: "aecc5c0aebd98d44043f93c744d1036750d4f9fd54fa7425d4bdf7374df1555c"
    sha256 cellar: :any,                 sonoma:         "41c87de7d3f88d04e60b9fcd9bfc349b25847ec974dc7b05299d29f70c0a0748"
    sha256 cellar: :any,                 ventura:        "6521fc1adf47ddb3be34572a4360f0c44a670b252f8e1c872b6cacf3c8626f46"
    sha256 cellar: :any,                 monterey:       "dc0ef1776d6249b5b3c23edad5c441d174abaa16b1798f837ea064f79c827554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7c159ec1ca7be1f4ba2a0241868f0771c960859bc513e8040fd9fafbdd48356"
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
