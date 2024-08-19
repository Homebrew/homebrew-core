class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.4/hfst-ospell-0.5.4.tar.bz2"
  sha256 "ab644c802f813a06a406656c3a873d31f6a999e13cafc9df68b03e76714eae0e"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ac3c8db816a221fb4d31304d7a3f911e5dbc26ea2a41c757bd23cbcfd095219"
    sha256 cellar: :any,                 arm64_ventura:  "ca1e9a08dc2804c886e2501717896a1b3c6656d168a4a6dd7f0a7cdbc186bae8"
    sha256 cellar: :any,                 arm64_monterey: "bce636afc077660217f0add724744471c59d3d23b6664737f8b576acccb789c1"
    sha256 cellar: :any,                 sonoma:         "5f63b59ba5001fb6a180921ed1954f3f9e24246a9ec550005f073c2f2ebed844"
    sha256 cellar: :any,                 ventura:        "1ad2317687be55cf5919f36fe0880d8b048c56b768222e345ef17840b43649b1"
    sha256 cellar: :any,                 monterey:       "b74b4d89c1b3e3fc69260ef95bf038138a6ef5a0f7ebb18418eb2a71bdbdcd6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65a917c07469f364dbe04c80c768aa2862c8a92495fe82c9ebaa47b02186bae5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"

  def install
    ENV.cxx11

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-libxmlpp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"hfst-ospell", "--version"
  end
end
