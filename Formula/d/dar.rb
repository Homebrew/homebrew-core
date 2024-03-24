class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.14/dar-2.7.14.tar.gz"
  sha256 "40d4dba44260df3a8ddce1e61f411ea9ab43c2cfc47bd83ab868c939d19dc582"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "31156786fa7a095921cdc62daf456468b6345054ff8eb0e9db8f332dd4eced13"
    sha256 arm64_ventura:  "cf669f8ee003ceb88f332007b4917201a393d2a44c0d7cd98879f60c4b735b73"
    sha256 arm64_monterey: "41b596c68a00d8fec878ac78a7f3259ae4fe18fc5eda33c3a03b50502fbfcd1f"
    sha256 sonoma:         "7007f32d466f5799e2a6ef8ccbccbfbb2bdc46b090790a7f13d23a70bb8eb187"
    sha256 ventura:        "ec56fbbeebc47e7b7602ab7cfaab2edf1a3735272ffca1b6fb9e66faf4249fc3"
    sha256 monterey:       "151640d96ef8788e8ade5877ecbfccea33e0bbece5cba1cefb581df5dca255ea"
    sha256 x86_64_linux:   "ec45bb0077c819f05093c511034cb14fefbc572133506d0a18b38bbea8496f56"
  end

  depends_on "argon2"
  depends_on "libgcrypt"
  depends_on "lzo"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-dependency-tracking",
                          "--disable-libxz-linking",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    mkdir "Library"
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
