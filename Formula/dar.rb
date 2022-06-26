class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.6/dar-2.7.6.tar.gz"
  sha256 "3d5e444891350768109d7e9051e26039bdeb906de30294e7e0d71105b87d6daa"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256               arm64_monterey: "07fb29f0d1099bed6ebb8f1704dba22dd2be8e9f709c83d5eb790a52234cafbc"
    sha256               arm64_big_sur:  "38a24276c643cf51652048b63d4d25ed766b46a5895137e3079420ad726315cd"
    sha256 cellar: :any, monterey:       "c791caab3de9c794d4c8e8fbaf928a550bc819b343bf10d086e758c26d6d2d27"
    sha256 cellar: :any, big_sur:        "1471725ed4a9718c3b8c98690963c327c96fa3e3f66823711938e68e56df59e5"
    sha256 cellar: :any, catalina:       "2c1d03575a50d09cf9290b9e0bfae2677308f0bfed36c2b72a7989f7008df5d7"
    sha256               x86_64_linux:   "c66a42b6b25ceeef4304473a7347ec3a62ac5b0bd2dbd79ba7227d2d69b21d03"
  end

  depends_on "upx" => :build unless Hardware::CPU.arm?
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
