class Powerman < Formula
  desc "Control (remotely and in parallel) switched power distribution units"
  homepage "https://github.com/chaos/powerman"
  url "https://github.com/chaos/powerman/releases/download/v2.4.4/powerman-2.4.4.tar.gz"
  sha256 "d675502144bc0875def92dad4c0efc6d43bc81c78d6fdb09ebc5f3558b3b7c85"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:    "2a025f4f16f450afaa40d3189d3f2725afd466850251d60bbe5db4aa0f2bcdbb"
    sha256 arm64_sequoia:  "54a0c75c35b58a6eb25dc9f56b019643b33fbfcc3b71f6d1316f2eb32447eb11"
    sha256 arm64_sonoma:   "6274589c50d20da83fdc311f6810716088ecdeab30dd079faffd7622694ae8ae"
    sha256 arm64_ventura:  "bed3bba37a720c974c0752e1026bafabf8c6c647b6cb344a372d3354429a15ee"
    sha256 arm64_monterey: "e218e0db90cd2e380ebfd077218c11dd0431006677e34a30fd253b73a3bdffaa"
    sha256 sonoma:         "86b2910601c00324092ad76240a00179fc9f957131804f621bd06f54af35d826"
    sha256 ventura:        "0e043048d342891a2062efc4a573b0d434276eb59401881cb30a90528ebcecbb"
    sha256 monterey:       "2df1fa862eaa9e2fa6c9af732f77430919cc6664db0a9a1e170029830cc3ea37"
    sha256 arm64_linux:    "20f73051a9c1de9c28dec2bd869631da3397d4cafe88f391b14a7aeb6093c6b4"
    sha256 x86_64_linux:   "995393b52583123c1791404fca6de037205ea8b8ae14817c817328a6eb3e7b96"
  end

  head do
    url "https://github.com/chaos/powerman.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "curl"
  depends_on "jansson"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--with-httppower",
                          "--with-ncurses",
                          "--without-genders",
                          "--without-snmppower",
                          "--without-tcp-wrappers"
    system "make", "install"
  end

  test do
    system "#{sbin}/powermand", "-h"
  end
end
