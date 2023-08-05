class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.11/dar-2.7.11.tar.gz"
  sha256 "41e084305a3f4f19babd0dc7156649ede339ca7b1fea6d4630231b8536295bc8"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "5aaf26f487198dc43d124cb5e7272a0da01b189006b5264796d89b3a639bcdb1"
    sha256 arm64_monterey: "dee6ab1f44b69e66962fcfb596313cc1181bbc719cd36c0658421ec037d19a61"
    sha256 arm64_big_sur:  "bf37cd1e5ca6c1c5829b9ad8db87628138112418cd50eca8ad95c104a7360267"
    sha256 ventura:        "893824649e24e0ed993c2074c5a65a3ec9b93491c1a5ffb6b321f4cd9764e113"
    sha256 monterey:       "b8114104f449548550d6d4a6e493a639508d221a7fc96b5b7440451294dd7c14"
    sha256 big_sur:        "b6967c732c55ae865259824a26482d921d7283be1211faedce0d9943b19f6d19"
    sha256 x86_64_linux:   "12cd34876b51ddea944f059e111d2f71086459fb1cdbfcc4bef4d3ee78f47435"
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
