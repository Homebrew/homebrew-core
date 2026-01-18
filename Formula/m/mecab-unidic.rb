class MecabUnidic < Formula
  desc "Morphological analyzer for MeCab"
  homepage "https://clrd.ninjal.ac.jp/unidic/en/"
  url "https://mirrors.dotsrc.org/osdn/unidic/58338/unidic-mecab-2.1.2_src.zip"
  mirror "https://clrd.ninjal.ac.jp/unidic_archive/cwj/2.1.2/unidic-mecab-2.1.2_src.zip"
  sha256 "6cce98269214ce7de6159f61a25ffc5b436375c098cc86d6aa98c0605cbf90d4"
  license any_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-3-Clause"]

  livecheck do
    url "https://clrd.ninjal.ac.jp/unidic/en/back_number_en.html"
    regex(/href=.*?unidic-mecab[._-]v?(\d+(?:\.\d+)+)[._-]src\.zip/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "41360acf4a7845341e5aa6b3dbd168c083797ad7931f5eb3bd4b40730b02276b"
  end

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    system "./configure", "--with-dicdir=#{lib}/mecab/dic/unidic", *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To enable mecab-unidic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
        dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic
    EOS
  end

  test do
    (testpath/"mecabrc").write <<~EOS
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
  end
end
