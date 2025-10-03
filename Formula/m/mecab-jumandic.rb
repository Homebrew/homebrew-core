class MecabJumandic < Formula
  desc "See mecab"
  homepage "https://taku910.github.io/mecab/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/mecab/mecab-jumandic-7.0-20130310.tar.gz"
  mirror "https://mirrors.ustc.edu.cn/macports/distfiles/mecab/mecab-jumandic-7.0-20130310.tar.gz"
  sha256 "eaf216758edee9a159bc3d02507007318686b9537943268c4565cc1f9ef07f15"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1916fed29c7a65bba61d492798c38869d624ea1496b03e77f2aca5ffd3cbfe9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "874bddec7db567b9cfc77eae8df900cf54264d6b047aa72ad5de27f10c257f0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ebf13ddcc0af473110b91b1ef375fd0e002d1d5069f90010760ea0c9477cc80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f033d5c87f53c348ad60a9de9e2f332248cc06d7c7bdfb32736ff86f2a9e080f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f033d5c87f53c348ad60a9de9e2f332248cc06d7c7bdfb32736ff86f2a9e080f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "467204e1c6b94ca425c3e18e5d1ac6d88965119dcea7403504790f592d762f1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ebf13ddcc0af473110b91b1ef375fd0e002d1d5069f90010760ea0c9477cc80"
    sha256 cellar: :any_skip_relocation, ventura:        "f033d5c87f53c348ad60a9de9e2f332248cc06d7c7bdfb32736ff86f2a9e080f"
    sha256 cellar: :any_skip_relocation, monterey:       "f033d5c87f53c348ad60a9de9e2f332248cc06d7c7bdfb32736ff86f2a9e080f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6da8172f0b7ac280bce9b4cbd35f1d7c0346c16e9470df605d6527a62fb30b7c"
    sha256 cellar: :any_skip_relocation, catalina:       "57d02ae309f76a73adeb47ddf1a02afaf21443c4516afadb0a4cb16b0b1a2a79"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "346aefc668bb17d6acb5990cf621a5c968d100654f3fbf92cac602cf92230e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c26464bbeb15378cbc88904a355bc5e3fca846cbd709a8d9d156c21822b2192"
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
