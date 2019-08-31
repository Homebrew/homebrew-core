class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://downloads.sourceforge.net/project/opensc/libp11/libp11-0.2.8.tar.gz"
  sha256 "a4121015503ade98074b5e2a2517fc8a139f8b28aed10021db2bb77283f40691"
  revision 1

  bottle do
    cellar :any
    sha256 "993754097514162c20e95e45646923c2071afd8387494935d7e112d0182499b5" => :mojave
    sha256 "9141155e8e615576c62fb4e8b3bb0f7f75d0954104a198423bbbb2a1b741f53e" => :high_sierra
    sha256 "6be0e0dc2f7dc8dee695cce025a0f55aba0b4f0f13a812ecc3b55047b9966cd8" => :sierra
    sha256 "9603d653971da9473b55452107f791466b3a66a02c9b6ef29dd78d87ca749331" => :el_capitan
    sha256 "1daf29346c2b73f53d9df61e42876f7d4c813389c0340e7b9385fb97b3e16a94" => :yosemite
    sha256 "2cb4d5a038448daee4c6c4078ea53afb88037645d8e28ef6a17e5644785f573d" => :mavericks
  end

  head do
    url "https://github.com/OpenSC/libp11.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "openssl" # no OpenSSL 1.1 support

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
