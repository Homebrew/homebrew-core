class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.8/dar-2.7.8.tar.gz"
  sha256 "74eadc5e657315b4f6aee018c95b625f04bdbbee39e5ec9ec4663533ee950fe9"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256               arm64_ventura:  "1ebfdff2606d3143aef45cf08ee56a076048479d28fd864a6ada3570b5f89bdc"
    sha256               arm64_monterey: "10d3c7bb9c0266b2d5a31e189b88a2b28ce6131ba5040f01210fddf2d6765e3d"
    sha256               arm64_big_sur:  "8e79ea81d12cb5b2f7aa061dd9fe04549ff440ecc322d5a278b5de7b6e8acc07"
    sha256 cellar: :any, monterey:       "d7d1ca1fd0b59185da504470e9946248b04aac7fa1163ef4f61578cb79d18d49"
    sha256 cellar: :any, big_sur:        "ad50c99bd6c49c7d6dcc8ab5415d7787e49607582608c483c00bbcca0cafc79c"
    sha256 cellar: :any, catalina:       "ea7ccf588f504d7a947fb47815d44da9088ebbb8eb64be8c653fbf74406589b5"
    sha256               x86_64_linux:   "16cad6bb257d467529187f3d2846e9e981b684e49ca319a5cf49084b85b03080"
  end

  depends_on "libgcrypt"
  depends_on "lzo"

  uses_from_macos "zlib"

  on_intel do
    depends_on "upx" => :build
  end

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
