class Mp3gain < Formula
  desc "Lossless mp3 normalizer with statistical analysis"
  homepage "https://mp3gain.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3gain/mp3gain/1.6.1/mp3gain-1_6_1-src.zip"
  version "1.6.1"
  sha256 "552e77f9333a04f35d68808565ec99b5eb6707985ea946f60f13c81a42daf25d"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c4fb949ec3332597b67bca10b87add64e0e2fd987dc4e3f1573ff21ad35358e" => :high_sierra
    sha256 "a9548ef1c648c0aaa4d203726431a5425518a7a2f54df0b6d5e8c92715404e3d" => :sierra
    sha256 "27506d45e11a7da5c9555cb17318cf99802d5a8749ad17ed66b7a4b1465790cd" => :el_capitan
    sha256 "f14681110117c1762ef909dc0b282bb4c23f298c92eefe20d77fab0199cadbaa" => :yosemite
    sha256 "17abc15792bc75fa186c6748f1cb666814334b2cfec11d708bb9431846746809" => :mavericks
  end

  depends_on "mpg123"

  def install
    system "make"
    bin.install "mp3gain"
  end
end
