class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  license "LGPL-2.1-or-later"

  stable do
    url "https://github.com/OpenSC/libp11/releases/download/libp11-0.4.11/libp11-0.4.11.tar.gz"
    sha256 "57d47a12a76fd92664ae30032cf969284ebac1dfc25bf824999d74b016d51366"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :stable
    regex(/^libp11[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "af7746ed36af308756e2da0de41e9e1f3f49bd9e2166d5d414c2b457d902cc76"
    sha256 cellar: :any, arm64_big_sur:  "8286261723f0d43eb331dfceffaa13057a23cb9acd6e12b21ccca834e3bbdad5"
    sha256 cellar: :any, monterey:       "dd15244317b7a9c12f6b2716d17fcb0a9204366448ff263437e5d85adbe28c98"
    sha256 cellar: :any, big_sur:        "b3887a8796d78e8cfe9a298490eebe9adc6459ed71963144dd057d2a1fd56f1b"
    sha256 cellar: :any, catalina:       "9da63ed34ade8ca89b600207b22d9fcc9a707aee31e3325f73c5da473e1df481"
    sha256 cellar: :any, mojave:         "14a94b35751b0b820206edecd55dd713079ea20a1e72b049d290b10283a80895"
    sha256 cellar: :any, high_sierra:    "95fac2824261ddc121f443a372174131eb9f31fe784a724bee7667af1302bba8"
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
