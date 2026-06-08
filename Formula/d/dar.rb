class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.8.5/dar-2.8.5.tar.gz"
  sha256 "9f3f9a7b344efba1672050d13b841e3834cef611a95be3ead50d69d5537828b2"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "eb37180c73852248df10a0a53fc315264437b22697e095f0eda153e898a2c547"
    sha256 arm64_sequoia: "a977303bfb8d718b7d4b424961208d2877188048f41948a2fe810d500c956a40"
    sha256 arm64_sonoma:  "7068a3a0a6ee2c6a98013ad08fddb93c8c9babe4cd53bcafed01b4f8f8771ffe"
    sha256 sonoma:        "7fa78b25f73be8f41c856e46ea5b5953d37b342d163abfe17b4cf7b3aaecb4be"
    sha256 arm64_linux:   "61384abee77dd84dec005e938e6a6a70e59d98630932d3996337f9c7d7140b34"
    sha256 x86_64_linux:  "a1afb91dd9cd66b96b1b2449d3f9e0ce1f216d71e9b17045a201f7cac65d1ecc"
  end

  depends_on "argon2"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz"
  depends_on "zstd"
  uses_from_macos "bzip2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-dependency-tracking",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    mkdir "Library"
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
