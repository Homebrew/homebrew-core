class Mp3gain < Formula
  desc "Lossless mp3 normalizer with statistical analysis"
  homepage "https://mp3gain.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3gain/mp3gain/1.6.2/mp3gain-1_6_2-src.zip"
  version "1.6.2"
  sha256 "5cc04732ef32850d5878b28fbd8b85798d979a025990654aceeaa379bcc9596d"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d0b9afb6732e4f32ba35895a1616512871c41680e677880db81be8035514651e"
    sha256 cellar: :any,                 arm64_monterey: "30ce022d5614764c00f9013d2b718e11672680e2dde038604d133a4ad8bc4b02"
    sha256 cellar: :any,                 arm64_big_sur:  "d4e92ab9bfc8143f4442f6d7c3f78a3ef92677d44198402ef5d05a604481b414"
    sha256 cellar: :any,                 ventura:        "55b9710be466fa70dba864853f6c4b1bb251b5bb8ea1f6a83e7ecc9fba3ec0f5"
    sha256 cellar: :any,                 monterey:       "2d18dd77dc786372e6cb010f3abc4f893492faece974b1cd46a40f9e53b6bc1a"
    sha256 cellar: :any,                 big_sur:        "d31ec490fe52fd92457325ec9d1161104283d1c16cee1c73c2d083a847d187e1"
    sha256 cellar: :any,                 catalina:       "27dbf67d73a4f63cd06cc568b8a40d09e3fec5e858c447da1750b2093046d795"
    sha256 cellar: :any,                 mojave:         "6db408b86b074e8713476fa60ea252ad3f4213dbf63cdca3342ffe989bd372d5"
    sha256 cellar: :any,                 high_sierra:    "5aa37ac4ab2013f5365da14969494111500337cae3c6d7614b72dfb9e94352f2"
    sha256 cellar: :any,                 sierra:         "66684a469ee1de432a00f1264c89b3921d3558854fa736b24a3942e351617c47"
    sha256 cellar: :any,                 el_capitan:     "4c97894216600ba8ac03094a45fe68a7d107f69adbcd638d40c967ad10e95480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a38486ace3008b4e9c5de0fa3d94c66c66108b5340e887ec0f322a3f9525d536"
  end

  depends_on "mpg123"

  def install
    system "make"
    bin.install "mp3gain"
  end

  test do
    system "#{bin}/mp3gain", "-v"
  end
end
