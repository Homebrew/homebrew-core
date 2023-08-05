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
    sha256 arm64_ventura:  "4480b7ae75d3ebccb96d1958faae7c48662ac6c8bdef67997285818449742acf"
    sha256 arm64_monterey: "bb77870777624db18c573f18cce90d721346d22d4df6fa374d48477242189cf5"
    sha256 arm64_big_sur:  "edcc26605485f3f1cf23349f14f522a7b0d8ec8e5a16125e721b3b0caa2dcd26"
    sha256 ventura:        "ae626bcb9245928c66b321e1edcd1b04f6ee208cdaa48df3123d495b02203d76"
    sha256 monterey:       "379aa7e4a6e5a7c8783821c029420c7ac6ab5d6f0904691821d1c7097c57fa72"
    sha256 big_sur:        "c124dda55fa4e7d893068e91198d527d50e3c6621c8613fa139b4a5eda40cdaf"
    sha256 x86_64_linux:   "a52e94d88fca64daa5a61d8868ed6d761b1951bcc49b7bef3fbfd4ccfc2ed8db"
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
