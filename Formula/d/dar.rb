class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.8.6/dar-2.8.6.tar.gz"
  sha256 "d56caeb6c86f751cb454d8fef45f3daecc508f208290d9f51e8c75bba5dc46c5"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "dbda0b52b4e634a5c7ab4c7d03c816d19d89b46b994089a498c6342e2d326ef2"
    sha256 arm64_sequoia: "dee1f6da3622811ddbeaf46fcd0e327b3f58676579549c85145ab65d91222bd1"
    sha256 arm64_sonoma:  "4d4ea89405b9eec241449fcd77cd350cda7002cbf3b11a7ac94f9ea495888a10"
    sha256 sonoma:        "a0e0b327460a4ee0e164e9ee9f37d8fb695cd9fc4705636385a11a388dd7d225"
    sha256 arm64_linux:   "ff4b96492d26596fd722dc7e66018e48d1b74e4b98956540a25469747d0c0a14"
    sha256 x86_64_linux:  "901c5795260fa37b2b9304baa8d0962f196635f142767694dc34d34d02f17b5a"
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
