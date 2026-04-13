class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.8.4/dar-2.8.4.tar.gz"
  sha256 "8e1ba552fd8b0783076d42ac1c2eeda57781c89f9bcc119f9d00ff1326e95e13"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "07e5000da7c10842c0a4904ee273e9181788a85c4d9f5b1b18523791e35953bc"
    sha256 arm64_sequoia: "084c50ac49485dd241cfc065c2c4253978041e613f2f331971a3aa3324152899"
    sha256 arm64_sonoma:  "8ab6262d49e9a6dc408a82e2a793d06c3548031009218d7500889850b0ccd4f7"
    sha256 sonoma:        "8f552ba3c2cd723a484c75d83795c81a2967d20fcf28159a0f22880423e8482b"
    sha256 arm64_linux:   "b9138c84125ec7dd04982d2fbeaac778c69a37aa346e372aa5366cb4119aaa34"
    sha256 x86_64_linux:  "b02825d5d9922187d2fc0d619488b43a7804a563215e4dea124630f77e9a5020"
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
