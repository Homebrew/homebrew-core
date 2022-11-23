class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://github.com/OpenSC/libp11/releases/download/libp11-0.4.12/libp11-0.4.12.tar.gz"
  sha256 "1e1a2533b3fcc45fde4da64c9c00261b1047f14c3f911377ebd1b147b3321cfd"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libp11[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0b843830831f3d40c2bc05cee086209403d332df6e69f6a08ad7bb9b9e86cb3a"
    sha256 cellar: :any,                 arm64_monterey: "7ff9bf5bc261f57e6396cf4db40d78fe76d8abef845b67bc6000b38b1308f34c"
    sha256 cellar: :any,                 arm64_big_sur:  "fb06eacdf6bdb6f8af71706a81aa5e70fdaaf6f4b8ca0fe285c0687ef9d4cb6f"
    sha256 cellar: :any,                 ventura:        "0dc75a7beb4af4db7767365658bc3b657d60548ac684d3ab3d79928150e91694"
    sha256 cellar: :any,                 monterey:       "58f4862ac40d50e7083ad99703f0302d9ba1269744c82263ea2e6aced957d6a4"
    sha256 cellar: :any,                 big_sur:        "cc2abf1c58255ebcd610a694e4c45496c6471d31a5fc917c98b15bc6e10fd4d8"
    sha256 cellar: :any,                 catalina:       "62236e2ad57894cc392306c0e4c1becff52b8054bb88baa65e01431babc8884e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "409cb2e2ff0a554ca1ae763da1065fe9fc499668d305457cd4dc24be09032fbf"
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
    system ENV.cc, pkgshare/"auth.c", "-I#{Formula["openssl@1.1"].include}",
                   "-L#{lib}", "-L#{Formula["openssl@1.1"].lib}",
                   "-lp11", "-lcrypto", "-o", "test"
  end
end
