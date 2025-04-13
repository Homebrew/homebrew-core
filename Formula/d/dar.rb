class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.17/dar-2.7.17.tar.gz"
  sha256 "4a597757d2de2f54821319129090ded8e67cff1a487c3d2e43b9daccefb5140b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "c1edb8bbd7c24b4449d558aa34c1e11f25e032a8e52545a273758b1540c28d67"
    sha256 arm64_sonoma:  "7c22d77abed655c9fe78c5f9bf82ef8afea3351508e6e5cae840aa289148a1f2"
    sha256 arm64_ventura: "a54bc17f46e2c74c4d4f9c36d655b9f7f37427f09ce0eef08d91a3d5df312254"
    sha256 sonoma:        "0bca4d8a3e1da533332fe535d0d35f7fd13d87db88cae93b5b444e427cdb3028"
    sha256 ventura:       "cbbeca869cc054e953129ebe8e992b4bf8af69d0bd64570b49a2ff6abc25646f"
    sha256 arm64_linux:   "b48d311bb953658903d6e2e84efeba2da0a94b7f9a8fa0488ea8786e2db61fd7"
    sha256 x86_64_linux:  "5c2f273a76143c4aa87aa957647ddb3e3373ffa661edb57a685eca84aaddb77c"
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
