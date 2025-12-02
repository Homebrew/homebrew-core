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
    rebuild 1
    sha256 arm64_tahoe:   "b858726b4a26f73aba47940eafea0a9116eff95a26bb0d1ced19793891502f99"
    sha256 arm64_sequoia: "b925104d7c81d541438f334cdad20b5514863fa0db3a288d4d3c0b37b728dc5e"
    sha256 arm64_sonoma:  "add2d890eb0e67aab3a81456b7fd7be79e09bc00de14a1c3fd8141a87c30beef"
    sha256 sonoma:        "d89f5be741fa7cb143121b9fd7cd49a027ebd68b37cc6783d9932bf2441eb8c6"
    sha256 arm64_linux:   "eb342aa21f80b119717d7b715cb122591c27858e00e727d0cb7f443e7a6c1ab1"
    sha256 x86_64_linux:  "39d25cf2c020a5a44ace257fc9ccc60d6d9ef57f46e5d623dafb4f2a006c99d9"
  end

  depends_on "argon2"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz"
  depends_on "zstd"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
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
