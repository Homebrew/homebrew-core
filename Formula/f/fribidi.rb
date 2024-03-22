class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.13/fribidi-1.0.13.tar.xz"
  sha256 "7fa16c80c81bd622f7b198d31356da139cc318a63fc7761217af4130903f54a2"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bc022e5da0135b6f991274ffd688eed3a3ed5332b1e9a1a26fffcef792e6bd87"
    sha256 cellar: :any,                 arm64_ventura:  "0272f179bac6809467c56eb0b1fac7f1de88b4c012fd36e77411aec39e5f9b4f"
    sha256 cellar: :any,                 arm64_monterey: "ad4a3ff427cd169933fcb3266e0b85c841d25cfa3d7883759bcf84f9655c59eb"
    sha256 cellar: :any,                 arm64_big_sur:  "d7c97dc2da426a3586d0c428f57d63300951ae23784769ebfdf3a4af0ab225f0"
    sha256 cellar: :any,                 sonoma:         "4f38b08fceaf4b1707a7931953d55ed00e556c08abd61449aef1dc9f1ecd2ee1"
    sha256 cellar: :any,                 ventura:        "df4ec1000cdaac83d1b712c838e2eb32a93c8ec7c7d7d47e2d199fe96501a435"
    sha256 cellar: :any,                 monterey:       "d2642675b0e7340ef0cc954a694b0d80e80f2b0b8b4e04f2f7ffe7b82aed1cd2"
    sha256 cellar: :any,                 big_sur:        "8ee3767e307b336a952f55d2c3c1a043bd2a8a88fc10889a7888e3c69207b105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4771f18b9338c897f39328998452a0aa4d03b7a13021e5303a12376170f3fb7d"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<~EOS
      a _lsimple _RteST_o th_oat
    EOS

    assert_match "a simple TSet that", shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
