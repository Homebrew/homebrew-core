class MecabJumandic < Formula
  desc "See mecab"
  homepage "https://taku910.github.io/mecab/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/mecab/mecab-jumandic-7.0-20130310.tar.gz"
  mirror "https://mirrors.ustc.edu.cn/macports/distfiles/mecab/mecab-jumandic-7.0-20130310.tar.gz"
  sha256 "eaf216758edee9a159bc3d02507007318686b9537943268c4565cc1f9ef07f15"

  bottle do
    cellar :any_skip_relocation
    sha256 "57d02ae309f76a73adeb47ddf1a02afaf21443c4516afadb0a4cb16b0b1a2a79" => :catalina
    sha256 "c9e83fb2bd4fd8aaa18b9475b512c7fb1e39a5903aca41ce23f9cccfdbdd0f09" => :mojave
    sha256 "eefafd1bf8ea2aa43a50542328ee97492beab4730e52c4ec8ce6ed06844e8382" => :high_sierra
    sha256 "4b821839b99982c506a1e262c9fa8b650620bc546a8725a5eaa1dc54b45e4822" => :sierra
    sha256 "4b821839b99982c506a1e262c9fa8b650620bc546a8725a5eaa1dc54b45e4822" => :el_capitan
    sha256 "4b821839b99982c506a1e262c9fa8b650620bc546a8725a5eaa1dc54b45e4822" => :yosemite
  end

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=utf8
      --with-dicdir=#{lib}/mecab/dic/jumandic
    ]

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To enable mecab-jumandic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
        dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/jumandic
    EOS
  end

  test do
    (testpath/"mecabrc").write <<~EOS
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/jumandic
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
  end
end
