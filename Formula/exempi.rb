class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.6.2.tar.bz2"
  sha256 "4d17d4c93df2a95da3e3172c45b7a5bf317dd31dafd1c7a340169728c7089d1d"
  license "BSD-3-Clause"

  livecheck do
    url "https://libopenraw.freedesktop.org/exempi/"
    regex(/href=.*?exempi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d23e4d16f857e7c2731c0e5b4fdec93f39ae7e2efd3bf4b77f6c0ff933cd2eef"
    sha256 cellar: :any,                 arm64_big_sur:  "b255cea38e3e87347611ba1f55701caa3237d0c4131384f39a025a0ecdaf56ec"
    sha256 cellar: :any,                 monterey:       "0d35c08aa3a560ec56a668374b9629e1d45d77430f3a035d009257749ec2367b"
    sha256 cellar: :any,                 big_sur:        "fdd02db94a10af5aa7ca1cc9b68f9bdade661fe0369927fb38f215ee0a60a64d"
    sha256 cellar: :any,                 catalina:       "bc25ba91bd7448d2424526f3a514a3b0e8ba22c99e079904792af0e0da06cdd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2ed682abe04a0958fa913ffd6a76fe21a81ddec7c506b123e0deb3171627a4d"
  end

  depends_on "boost"

  uses_from_macos "expat"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
