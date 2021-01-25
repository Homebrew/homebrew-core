class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://github.com/OpenSC/libp11/releases/download/libp11-0.4.11/libp11-0.4.11.tar.gz"
  sha256 "57d47a12a76fd92664ae30032cf969284ebac1dfc25bf824999d74b016d51366"
  license "LGPL-2.1-or-later"

  livecheck do
    url :head
    regex(/^libp11[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "b3887a8796d78e8cfe9a298490eebe9adc6459ed71963144dd057d2a1fd56f1b" => :big_sur
    sha256 "8286261723f0d43eb331dfceffaa13057a23cb9acd6e12b21ccca834e3bbdad5" => :arm64_big_sur
    sha256 "9da63ed34ade8ca89b600207b22d9fcc9a707aee31e3325f73c5da473e1df481" => :catalina
    sha256 "14a94b35751b0b820206edecd55dd713079ea20a1e72b049d290b10283a80895" => :mojave
    sha256 "95fac2824261ddc121f443a372174131eb9f31fe784a724bee7667af1302bba8" => :high_sierra
  end

  head do
    url "https://github.com/OpenSC/libp11.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "openssl@1.1"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-enginesdir=#{lib}/engines-1.1"
    system "make", "install"
    pkgshare.install "examples/auth.c"
  end

  test do
    system ENV.cc, "-I#{Formula["openssl@1.1"].include}", "-L#{lib}",
                   "-L#{Formula["openssl@1.1"].lib}", "-lp11", "-lcrypto",
                   pkgshare/"auth.c", "-o", "test"
  end
end
