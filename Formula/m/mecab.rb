class Mecab < Formula
  desc "Yet another part-of-speech and morphological analyzer"
  homepage "https://taku910.github.io/mecab/"
  # Canonical url is https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE
  url "https://deb.debian.org/debian/pool/main/m/mecab/mecab_0.996.orig.tar.gz"
  sha256 "e073325783135b72e666145c781bb48fada583d5224fb2490fb6c1403ba69c59"

  livecheck do
    url :homepage
    regex(/mecab[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 arm64_ventura:  "492e9bdfcbb7968c03dff7736cd94ba5ad97df0c164bb62c1fe9f9e389881ceb"
    sha256 arm64_monterey: "868884cacf2503757291056a3cee77daaba404fd43abeeb0b2dc7e0a6fceee29"
    sha256 arm64_big_sur:  "495c42533a5ea5bdedcf4a95c05e613c3579f626b17d0df0396d8a0ea9328bbe"
    sha256 ventura:        "9bd251f2b61cab5850ac818ac06b879889c8c9c88c54c7163920099938c76b0d"
    sha256 monterey:       "839a67ae318170dea1c0ea8f3e55d8c5291da3e77ad0d62491fa656cf5539a18"
    sha256 big_sur:        "53efb8669f932aac26f4669db62eb858e6e31860923460a6c4e74d84685e8146"
    sha256 catalina:       "dba6306bcd5ddb9a824cb366b5432a036889440f2253634c99410fbb0abe0047"
    sha256 mojave:         "ef261d203140305ca8c9e4b7311c61176a17325df9454610d3eb33a312c4d3c5"
    sha256 high_sierra:    "d48340df17075e4a6237ffb87306a42566f8eabb736c546d790586266758f387"
    sha256 sierra:         "d98686ec62189de50f6ed5b7e682d59b90239c8dfd08cf32fd23543466586232"
    sha256 el_capitan:     "03df92bdd092065a7cbca5953a0e352c16cadfff5c9f186bbe1ee882258e56d3"
    sha256 x86_64_linux:   "47d2d29a34af53a9343cc99277fd19df64d0148e80007a19a2215e79b201a2a4"
  end

  conflicts_with "mecab-ko", because: "both install mecab binaries"

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
