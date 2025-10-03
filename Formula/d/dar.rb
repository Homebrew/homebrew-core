class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.8.1/dar-2.8.1.tar.gz"
  sha256 "217843cfb55ca99ccb38349f4778efd24de461aeee6f3d70ceacd1d9a4f492a4"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "1f5d17e89b08bd7a9b94571a18186f14dc97917cd6c21cf4c2642954b19fd24d"
    sha256 arm64_sequoia: "405575d7a811c346f3249384f847cd5fd7f4d512afc0c2b49057956f56a98426"
    sha256 arm64_sonoma:  "61f89387b2e95c92a88d23d1ac764d03d425d7d33f5d7fdaed7b5e8f7f81957b"
    sha256 sonoma:        "2b2d95e0808b63e83c3a33053c3e9a2e4b5e5872d096be9b735ea492f155324e"
    sha256 arm64_linux:   "5a387cee02160605f77c00c04c7178f7c566dc20da753d0397be0e9b6638d419"
    sha256 x86_64_linux:  "84ca78d59f5a46310edc3985a6779e4f2a6700a83b7515bfba1843963626abd2"
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
