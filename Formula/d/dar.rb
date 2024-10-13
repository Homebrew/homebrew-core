class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.15/dar-2.7.15.tar.gz"
  sha256 "fac56b59b78b5435ee19541ff4bd3dc329c8252ff78749ffea240f6421534bfe"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia:  "a1fe2166abd91e99aa2d813f02d8bcf5f00ec69d958a83d77a58cf8d52d7034a"
    sha256 arm64_sonoma:   "79f05ae92d1ccba3e57273d8db60335098b819f3b33df7e4c5b04c5a76043df3"
    sha256 arm64_ventura:  "b83527a092546bbdc2a8af12c3f1a4eb648669d535d0ba8662138855e92b545c"
    sha256 arm64_monterey: "8894d4a9043e1bca1e7916a01fa7e207bd894f83a99ad0b5f7aa60ef7a8fa209"
    sha256 sonoma:         "0c31fb296286cfb881a4ad2220ae1b4b2d4f50d5b223af64cd06492a79bc87fd"
    sha256 ventura:        "239601d4bd4fc347239f7b1360d588c4596752f7ad5d33c34f93847a191da871"
    sha256 monterey:       "65961ced78cb512e29cff86fcf218fa1c818a47f6088351a966fde66eb3e4fe3"
    sha256 x86_64_linux:   "85301842381745b10952ce739ba6af415c897e1adc1863748dbf8ae80885c672"
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
