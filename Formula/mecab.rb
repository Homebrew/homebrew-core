class Mecab < Formula
  desc "Yet another part-of-speech and morphological analyzer"
  homepage "https://taku910.github.io/mecab/"
  # Canonical url is https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mecab/mecab_0.996.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/mecab/mecab_0.996.orig.tar.gz"
  sha256 "e073325783135b72e666145c781bb48fada583d5224fb2490fb6c1403ba69c59"

  bottle do
    rebuild 3
    sha256 "ef261d203140305ca8c9e4b7311c61176a17325df9454610d3eb33a312c4d3c5" => :mojave
    sha256 "d48340df17075e4a6237ffb87306a42566f8eabb736c546d790586266758f387" => :high_sierra
    sha256 "d98686ec62189de50f6ed5b7e682d59b90239c8dfd08cf32fd23543466586232" => :sierra
    sha256 "03df92bdd092065a7cbca5953a0e352c16cadfff5c9f186bbe1ee882258e56d3" => :el_capitan
  end

  conflicts_with "mecab-ko", :because => "both install mecab binaries"

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
