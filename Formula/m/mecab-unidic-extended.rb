class MecabUnidicExtended < Formula
  desc "Extended morphological analyzer for MeCab"
  homepage "https://clrd.ninjal.ac.jp/unidic/en/back_number_en.html"
  url "https://mirrors.dotsrc.org/osdn/unidic/58338/unidic-mecab_kana-accent-2.1.2_src.zip"
  mirror "https://clrd.ninjal.ac.jp/unidic_archive/cwj/2.1.2/unidic-mecab_kana-accent-2.1.2_src.zip"
  sha256 "6cce98269214ce7de6159f61a25ffc5b436375c098cc86d6aa98c0605cbf90d4"
  license any_of: ["BSD-3-Clause", "GPL-2.0-only", "LGPL-2.1-only"]

  # The OSDN releases page asynchronously fetches separate HTML for each
  # release, so we can't easily check the related archive file names.
  # NOTE: If/when a new version appears, please manually check the releases
  # page to confirm an appropriate archive is available for this formula.
  livecheck do
    formula "mecab-unidic"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "16217e32273610a5314c981b56a06476002a596ad3e17af6bd8ad48adf7f8f23"
  end

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    system "./configure", "--with-dicdir=#{lib}/mecab/dic/unidic-extended", *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To enable mecab-unidic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
        dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic-extended
    EOS
  end

  test do
    (testpath/"mecabrc").write <<~EOS
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic-extended
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
  end
end
