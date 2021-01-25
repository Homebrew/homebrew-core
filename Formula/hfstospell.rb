class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.2/hfst-ospell-0.5.2.tar.bz2"
  sha256 "ab9ccf3c2165c0efd8dd514e0bf9116e86a8a079d712c0ed6c2fabf0052e9aa4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "c4eea86c022f9650a5aa07422b218f58a7007a6261ca330bd14b70ca0a58942d" => :big_sur
    sha256 "d97b466d38e3e05645cdad74fa1318b915b312c5cfac27f6b756f36862283040" => :arm64_big_sur
    sha256 "73ed82308ae27989db1584b449a0035220b4f9eb1dc70df6d311c361e06f5201" => :catalina
    sha256 "dda1e98815f201c5598441c4e4b16b2ed9502c15c2f159c04a289b711233f697" => :mojave
    sha256 "e37d41f7279ce5c4f26f4e3b61b459690980a2a39e96e948ac4e0002a46174d7" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"

  def install
    ENV.cxx11
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-libxmlpp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
