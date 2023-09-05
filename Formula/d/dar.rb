class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.12/dar-2.7.12.tar.gz"
  sha256 "800c5d89cc4f0b599166aab443e0a14abd7cef2f997418f06c48a8819000ddb3"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "a20d413b5e9aaea8bcdcd9f08e7cdf98985b6417599954d2f202292eeb9e2805"
    sha256 arm64_monterey: "b18d4436d2087c3d3798e6fcb590b40f0e6e6d9d625fc7920a5d63da7c50ad70"
    sha256 arm64_big_sur:  "c8148b404298341d0b9fadd2d9160a6a6703a95eb7bfcfe60f65f3a6f8f0c921"
    sha256 ventura:        "70a81cb7e281971d388a37dd31264a195692a616b23c8966194882a9d8ad1d73"
    sha256 monterey:       "2a6d786907dd73af3a64ebb58258268714d610b378fd8c9102abbee6ae1ec6ae"
    sha256 big_sur:        "23a689bfd3b44083525849d8ffc14b5cb9ee1df88370a9479e1285decd421dfe"
    sha256 x86_64_linux:   "89e69ccdbc8236b2eb64953fe5b490990fad9c00227610bf97e20c502713b5ca"
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
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
