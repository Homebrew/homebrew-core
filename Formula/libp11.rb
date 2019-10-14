class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://github.com/OpenSC/libp11/releases/download/libp11-0.4.10/libp11-0.4.10.tar.gz"
  sha256 "639ea43c3341e267214b712e1e5e12397fd2d350899e673dd1220f3c6b8e3db4"

  bottle do
    cellar :any
    sha256 "6b02a04559e7c4559dafde0dd6b44fbb22680c469381a9da1dc8cd3111abf939" => :catalina
    sha256 "299c595c75da2c84b3dfd6212658a7366cea9f5a13a279cc018ff824e00aef3e" => :mojave
    sha256 "9396b3dafa8e7c8a4e7f85aa2cd2a13a7cc94786cf3f99cf2a4707e2e40b3d2b" => :high_sierra
    sha256 "a4cefbde247f06a16d5aa14b7fbc04f1ae67f3b3caa2653d1311681deea2ad55" => :sierra
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
