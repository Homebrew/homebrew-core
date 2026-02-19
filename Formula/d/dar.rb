class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.8.3/dar-2.8.3.tar.gz"
  sha256 "812648f4d85fa2fe63ddad811f1c392f02c8627b54f9a610a1b54f51fbd96512"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a89b76d0eb86bed7773270b302be1078fb99ed4519c90ac1141c5d6e95d4a234"
    sha256 arm64_sequoia: "0cae402552a71973b57dd93e21468d23da7a63fd7f73b96bf59270583f7de5f2"
    sha256 arm64_sonoma:  "b8228fcc1823db1813d63043250d5f3a1c60167faa57d7b1c91e412ba0462502"
    sha256 sonoma:        "84e2a07f334e66aa5113cd80a65e790a44ed37a399c1896abf9eb1e05addd2c0"
    sha256 arm64_linux:   "ed9f4fa5b46976b874a30d54821f8074bccb8cdd89af87272eb99016a63778b2"
    sha256 x86_64_linux:  "b5ffd456fb6495fd271d8470c5ae099f9f00bfa6e0c81e0be69cb4428055fffe"
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
