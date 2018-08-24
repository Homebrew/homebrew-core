class Mp3gain < Formula
  desc "Lossless mp3 normalizer with statistical analysis"
  homepage "https://mp3gain.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3gain/mp3gain/1.6.2/mp3gain-1_6_2-src.zip"
  version "1.6.2"
  sha256 "5cc04732ef32850d5878b28fbd8b85798d979a025990654aceeaa379bcc9596d"

  bottle do
    cellar :any
    sha256 "6db408b86b074e8713476fa60ea252ad3f4213dbf63cdca3342ffe989bd372d5" => :mojave
    sha256 "5aa37ac4ab2013f5365da14969494111500337cae3c6d7614b72dfb9e94352f2" => :high_sierra
    sha256 "66684a469ee1de432a00f1264c89b3921d3558854fa736b24a3942e351617c47" => :sierra
    sha256 "4c97894216600ba8ac03094a45fe68a7d107f69adbcd638d40c967ad10e95480" => :el_capitan
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
