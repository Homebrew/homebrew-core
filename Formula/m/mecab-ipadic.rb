class MecabIpadic < Formula
  desc "IPA dictionary compiled for MeCab"
  homepage "https://taku910.github.io/mecab/"
  # Canonical url is https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM
  url "https://deb.debian.org/debian/pool/main/m/mecab-ipadic/mecab-ipadic_2.7.0-20070801+main.orig.tar.gz"
  version "2.7.0-20070801"
  sha256 "b62f527d881c504576baed9c6ef6561554658b175ce6ae0096a60307e49e3523"
  license "NAIST-2003"

  # We check the Debian index page because the first-party website uses a Google
  # Drive download URL and doesn't list the version in any other way, so we
  # can't identify the newest version there.
  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/mecab-ipadic/"
    regex(/href=.*?mecab-ipadic[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)(?:\+main)?\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3bdeed6d823a573bbac30e4994b79e26ae025379d2cb9b2193128b0cda7aca85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b0b12716ef5436fca113fb97c824e532b50b86ef59cb5b035498d00f54579286"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ab9a752833b99a87201dc1217e3774ca21aac1a87971dac1196bed13d1b428a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23c4ce0042e583b45fe99a339a10c481f80d5d2055ca896924e3e4c764460dc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68eec45d5e084ffeab687ccd95391dcbb1cfd80ddb73232253304a1ea1fb0be0"
    sha256 cellar: :any_skip_relocation, sonoma:         "12212f7bc769338a7747d2ac184bf669454486336ca32335f15f140d3a0121bf"
    sha256 cellar: :any_skip_relocation, ventura:        "d901a98d8d01869855c5e55a35f4c252749306ee5a5eb44030f8c811885b44ed"
    sha256 cellar: :any_skip_relocation, monterey:       "6285de6570c904239f3f07fe0b8bb5c707b23c0741e36170ebc28aaed3da0b6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0c7669401d92374cb6f57a0f71be0b65bc73c0fabcd62e1d2fd0480cadf9d697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23ec6f722695c38dc93487d1320dc7e34c79b359647d4c8edd2cef0a045ed851"
  end

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=utf8
      --with-dicdir=#{lib}/mecab/dic/ipadic
    ]

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To enable mecab-ipadic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
        dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/ipadic
    EOS
  end

  test do
    (testpath/"mecabrc").write <<~EOS
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/ipadic
    EOS

    assert_match "名詞", pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
    assert_match "名詞,固有名詞,組織", pipe_output("mecab --rcfile=#{testpath}/mecabrc", "A\n")
  end
end
