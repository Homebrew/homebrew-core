class MecabKo < Formula
  desc "See mecab"
  homepage "https://bitbucket.org/eunjeon/mecab-ko"
  url "https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.2.tar.gz"
  version "0.996-ko-0.9.2"
  sha256 "d0e0f696fc33c2183307d4eb87ec3b17845f90b81bf843bd0981e574ee3c38cb"

  livecheck do
    url :stable
    regex(/href=.*?mecab[._-]v?(\d+(?:\.\d+)+-ko-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "3b7edb46e117b0dd5df069ae3ce9be8d46df3a1905f2b5141550bf5f2be2124e"
    sha256 arm64_monterey: "188bfe25ec8b456e29e7668a704da223ef5999b5e9f5ff0dafb0b344e7094734"
    sha256 arm64_big_sur:  "bed085afe970086d2415a7412c95b09ecd016d40c7a0b0b041edc70a6e53b069"
    sha256 ventura:        "bfa6ae7a3d0da90d1089d0a3b2dfd83f229ef482ab51302a1a28a2599c073f4f"
    sha256 monterey:       "78a7f912badfb92dd7b251ac0b62b958e9f6e4b09fe43b5fc6251beefb5454dc"
    sha256 big_sur:        "5a551a2a040daff922d7eebc686a56fa89ca310aab415e8f1ddd743983442926"
    sha256 catalina:       "d9655e7122ee6a56194faf5e44062c3bf3c2bf145ba6f8f7b3e6dd1154bf7516"
    sha256 mojave:         "a1a0b40d2cb5a689ae24a439af990c7a85f8136bfa2bc5c3fd0708300b2fd111"
    sha256 high_sierra:    "d254239a9fec5e99de9590feb8d7c82f87e31324908003b059aea9a5d6092f2a"
    sha256 sierra:         "86b35c767cb97ab0b5e895475c3254589b101bdc3c8666abc694ea9a480421ec"
    sha256 el_capitan:     "c348042904040c28772c3f8f299debe574c6ebaaed7e41b23cac4980aeb8aa97"
    sha256 x86_64_linux:   "15f29ad6bf47615efaeab3db5f5108ee7232fc3c31cd905c7524b619d0bab818"
  end

  conflicts_with "mecab", because: "both install mecab binaries"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"

    # Put dic files in HOMEBREW_PREFIX/lib instead of lib
    inreplace "#{bin}/mecab-config", "${exec_prefix}/lib/mecab/dic", "#{HOMEBREW_PREFIX}/lib/mecab/dic"
    inreplace "#{etc}/mecabrc", "#{lib}/mecab/dic", "#{HOMEBREW_PREFIX}/lib/mecab/dic"
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/mecab/dic").mkpath
  end

  test do
    assert_equal "#{HOMEBREW_PREFIX}/lib/mecab/dic", shell_output("#{bin}/mecab-config --dicdir").chomp
  end
end
