class MecabUnidicExtended < Formula
  desc "Extended morphological analyzer for MeCab"
  homepage "https://osdn.jp/projects/unidic/"
  url "https://ja.osdn.net/frs/redir.php?f=%2Funidic%2F58338%2Funidic-mecab_kana-accent-2.1.2_src.zip"
  sha256 "70793cacda81b403eda71736cc180f3144303623755a612b13e1dffeb6554591"

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-dicdir=#{lib}/mecab/dic/unidic-extended"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
     To enable mecab-unidic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
       dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic-extended
    EOS
  end

  test do
    (testpath/"mecabrc").write <<-EOS.undent
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic-extended
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
  end
end
