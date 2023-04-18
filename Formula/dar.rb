class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.9/dar-2.7.9.tar.gz"
  sha256 "1c609f691f99e6a868c0a6fcf70d2f5d2adee5dc3c0cbf374e69983129677df5"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "47f220d659367a0098936e2697fef01b9cc2c49f3715fb0b50a16ef23c4fd927"
    sha256 arm64_monterey: "85a0849487757f13941c3f1dbcefd584340c963a92a266ebe27ea6d09b8b9990"
    sha256 arm64_big_sur:  "44b35f1cb406249c14b156320628097bb8bc16cebdfc912af9d92b878985d149"
    sha256 ventura:        "2c1c7f8fece7a12e09b3b76829e0746e4b479c97aa90d6a17c783751d997fdad"
    sha256 monterey:       "6c4c0d6e2a7d1c27e9a7537ac8f7981e9f14c2875d1c1cdba7b4cc37b0251149"
    sha256 big_sur:        "dafa054370b41b2e044e5aaec0c3893b04e912e1ea4af7e207517f4dede2055d"
    sha256 x86_64_linux:   "f27e08cfabdc944c092d7745f39673bfc28b11c849afa2ba993d6e02f0b5f8b3"
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
