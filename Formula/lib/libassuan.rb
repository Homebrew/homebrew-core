class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.7.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.5.7.tar.bz2"
  sha256 "0103081ffc27838a2e50479153ca105e873d3d65d8a9593282e9c94c7e6afb76"
  license "GPL-3.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libassuan/"
    regex(/href=.*?libassuan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6b2f1d6181e0a12955a60e6ee2f2d6bcdf489f898986ba0ab35b583f0f3e1d1"
    sha256 cellar: :any,                 arm64_ventura:  "46b1c3401d74b1712ae9858ec44d9018862238e11ac0b956d5705a82c0591e12"
    sha256 cellar: :any,                 arm64_monterey: "8913222f8bce3392df60072c27313af9dca61cb5678cec0f23e8bd8d28168bfd"
    sha256 cellar: :any,                 arm64_big_sur:  "54abc438b9b44aec5933b14393e4ef139f61feca860bbc71f43c355a2754c1db"
    sha256 cellar: :any,                 sonoma:         "7e7849c151251ada88d638136dfe0013f63334682ea8ddc7ff19322d86e009d2"
    sha256 cellar: :any,                 ventura:        "bfd5c6760f0da3d77fbca66fe1a44b94ec029919376a5ad1904b88c27bdf607b"
    sha256 cellar: :any,                 monterey:       "de2d641bac4bc28d4d41cb29284ad24ecf8c1cc2e609056ae5478a81ef17785d"
    sha256 cellar: :any,                 big_sur:        "25750195f585a93c86ff5b150161cd09cbaea3f9a036ec5aad0dafa7c93417d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc27800b95d9c358d6e7d9ef5f6efe56535d08c98bde7c5b028b5d155103f179"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libassuan-config", prefix, opt_prefix
  end

  test do
    system bin/"libassuan-config", "--version"
  end
end
