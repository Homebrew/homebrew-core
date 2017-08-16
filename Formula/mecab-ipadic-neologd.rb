class MecabIpadicNeologd < Formula
  desc "Neologism dictionary for MeCab"
  homepage "https://github.com/neologd/mecab-ipadic-neologd"
  url "https://github.com/neologd/mecab-ipadic-neologd/archive/b815a08d0478714007856d53f13551c92e9b0b5c.tar.gz"
  version "20170807"
  sha256 "ad134f17eae4469b16eb5506cf5dfb11bae248ccb0f0936afacd9179d1be8e5b"

  depends_on "mecab"
  depends_on "xz" => :build

  def install
    args = %W[
      --prefix #{lib}/mecab/dic/ipadic-neologd
      --forceyes
    ]

    mkdir_p "#{lib}/mecab/dic/ipadic-neologd"
    system "./bin/install-mecab-ipadic-neologd", *args
  end

  def caveats; <<-EOS.undent
     To enable mecab-ipadic-neologd dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
       dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/ipadic-neologd
    EOS
  end

  test do
    (testpath/"mecabrc").write <<-EOS.undent
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/ipadic-neologd
    EOS

    assert_equal "10日\t名詞,固有名詞,一般,*,*,*,10日,トオカ,トオカ\nEOS\n", pipe_output("mecab --rcfile=#{testpath}/mecabrc", "10日\n", 0)
  end
end
