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
    sha256               arm64_monterey: "7f20df64aafb36d36fe5358671181d8ccfd823309021d9fda73ecc42b136172a"
    sha256               arm64_big_sur:  "4d0647ae195d1187db88681f97661f0a49055e073129e2fcc5af397ec4cf0f10"
    sha256 cellar: :any, monterey:       "333a1449a01e838cd6f397289469138fcdf40cfe682cd8be9a1c64bf4cf3adc3"
    sha256 cellar: :any, big_sur:        "e3e74755ae632c5b1a9b24d06fde5f0bfa5ba1b3932747f0309ac61951b0c857"
    sha256 cellar: :any, catalina:       "20da0e2daab9957af7f8464204cd60cd3bbbf4afd5e1eaa0b333384b47d8b248"
    sha256               x86_64_linux:   "2d20b095aa0458c5091d0de869dde7505e3f7685533edc1b1204a121f7bdb46f"
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
