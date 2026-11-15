class MecabUnidicExtended < Formula
  desc "Extended morphological analyzer for MeCab"
  homepage "https://clrd.ninjal.ac.jp/unidic/en/back_number_en.html"
  url "https://clrd.ninjal.ac.jp/unidic_archive/cwj/2.1.2/unidic-mecab_kana-accent-2.1.2_src.zip"
  sha256 "70793cacda81b403eda71736cc180f3144303623755a612b13e1dffeb6554591"
  license any_of: ["BSD-3-Clause", "GPL-2.0-only", "LGPL-2.1-only"]

  # The OSDN releases page asynchronously fetches separate HTML for each
  # release, so we can't easily check the related archive file names.
  # NOTE: If/when a new version appears, please manually check the releases
  # page to confirm an appropriate archive is available for this formula.
  livecheck do
    formula "mecab-unidic"
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "5c9eebc9df1254cf1dd0a6247f4a84f582755f5bb07eca9bd70b7cc6737b0294"
  end

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  deny_network_access!

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
