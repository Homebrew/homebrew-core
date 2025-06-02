class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.18/dar-2.7.18.tar.gz"
  sha256 "6131b7d6d79a093bfcb320abbb90df941df8e9bc73f89ae6410bccdeffa5eb46"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "c6ed9371b7e5203385c32c792ed7828803aa2d3f924fdcae627c556408ea550a"
    sha256 arm64_sonoma:  "fb6c4236f27c2716a3ebb589ec52b6808dcbfe175d58556962fa1d949cf70d05"
    sha256 arm64_ventura: "187b84cbfc58815808a327357f55713dfe6d049bb6f169eb642db5bbff06e328"
    sha256 sonoma:        "3e4a651e548e018c9f0f4761759e5f9f955c4aca925777fdb02df201e4db3d80"
    sha256 ventura:       "69e51d3e93a69a3e5b37e5a84fd503ecca2293868adc15a5a54506541474cf07"
    sha256 arm64_linux:   "3ebb2f92ba45ba9e6b75ff28ab2011a2839c5bff0a5cbc1de5a161d504e3b952"
    sha256 x86_64_linux:  "bce142259c9f933d7dcd507a79f2d4e327841fe4e022a4537fbfb6b7533f5a47"
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
