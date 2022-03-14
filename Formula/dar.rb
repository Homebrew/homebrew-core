class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.4/dar-2.7.4.tar.gz"
  sha256 "7acb62d905e8abee5b89ceb7f5e1bdeaf64e4896e83151e60fea1134023a89ce"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, monterey:     "c1b73c7aa6c75e3e09b9f3417dab0058f95783d874a822a4d0da08b4da1ef1b6"
    sha256 cellar: :any, big_sur:      "5f44e68f9645585879ab93b80f63ebec7c2dfa0b9da23121cdfe5b9e6d0364ec"
    sha256 cellar: :any, catalina:     "85164777e8d6fc5eca25bf2ea6ec30db3f139f7b4aa8e5c040ff2c63f4cb0502"
    sha256               x86_64_linux: "51757e65e184a21baa924cf987bc201f4d97345dbcd8da90260e488dfe6bc8db"
  end

  depends_on "upx" => :build
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
