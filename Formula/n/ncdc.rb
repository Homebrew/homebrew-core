class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.24.1.tar.gz"
  sha256 "2a8ab9ad7d43f018fc73ba8babd689dfa44aba8cec53b88e4770185cb97778f7"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ncdc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "13803ef57b3a3d6667f18f905028c90bfb530d9e5acd8111f45b437d0cb737c4"
    sha256 cellar: :any,                 arm64_sonoma:   "f884fa65e0a6aaa95760bdb4d91c12afacdf22b74ffb375a39a2972d43fabf1c"
    sha256 cellar: :any,                 arm64_ventura:  "f124ac7652a0e93dde6d7c6c510f480f16ffea499e6c961231d039148dfc6ffb"
    sha256 cellar: :any,                 arm64_monterey: "376708c070cc338a43aa667c5c630cc68bbd7c42210b7575037362ff3bd7c164"
    sha256 cellar: :any,                 sonoma:         "6cf5a1ce79a0388917e3373edd356cecf6ba40f2397099771df2716d86a4f79d"
    sha256 cellar: :any,                 ventura:        "8e369c78a9451732e39333de521b367de84c3479220d3d22fdba3a1ff8eb6d09"
    sha256 cellar: :any,                 monterey:       "2d2701fd69a852d40c759a29dc44d4bf8adec22e0f1f9b220df923bcb8726ca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b371dba9e7e1c26d81886ac469eee57844f9476b78f6f3873b9aba04b9d8fbfc"
  end

  head do
    url "https://g.blicky.net/ncdc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "ncurses"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ncdc", "-v"
  end
end
