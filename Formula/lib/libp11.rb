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
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "6af6b0d767af1cb7ec7c3a7265bbdeafb86921fc2e7f5966be2efc9007b8a3d2"
    sha256 cellar: :any,                 arm64_monterey: "0be4080fadb8580fe8b9618dc2a37670919dc21a0a22d4375d295c3fa40aee98"
    sha256 cellar: :any,                 arm64_big_sur:  "2c61eab1e9b91d1158a719ca59253a3b65562a7f55c32909319b5359bca5e705"
    sha256 cellar: :any,                 ventura:        "da2d7d7a89310ef22f4326c9128f491961bff43ded083b1b52e8240076777c44"
    sha256 cellar: :any,                 monterey:       "0cc69d822cbf9a934c9c72e1ff421958367333a9fa69f060fba581afb58731c5"
    sha256 cellar: :any,                 big_sur:        "1546eb96b8f270994559dc63591f852ef0f6fbbcf93f92c8e8071a60db2cb9d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6370c44a401aca7e4f6fe02e2220a1c8b8791d697f8c88dbb5a0a2de0c297349"
  end

  head do
    url "https://github.com/OpenSC/libp11.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "openssl@3"

  def install
    openssl = deps.find { |d| d.name.match?(/^openssl/) }
                  .to_formula
    enginesdir = Utils.safe_popen_read("pkg-config", "--variable=enginesdir", "libcrypto").chomp
    enginesdir.sub!(openssl.prefix.realpath, prefix)

    system "./bootstrap" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-enginesdir=#{enginesdir}"
    system "make", "install"
    pkgshare.install "examples/auth.c"
  end

  test do
    system ENV.cc, pkgshare/"auth.c", "-I#{Formula["openssl@3"].include}",
                   "-L#{lib}", "-L#{Formula["openssl@3"].lib}",
                   "-lp11", "-lcrypto", "-o", "test"
  end
end
