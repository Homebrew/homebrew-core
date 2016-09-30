class Mp3gain < Formula
  desc "Lossless mp3 normalizer with statistical analysis"
  homepage "http://mp3gain.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mp3gain/mp3gain/1.5.2/mp3gain-1_5_2_r2-src.zip"
  version "1.5.2"
  sha256 "3378d32c8333c14f57622802f6a92b725f36ee45a6b181657b595b1b5d64260f"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9548ef1c648c0aaa4d203726431a5425518a7a2f54df0b6d5e8c92715404e3d" => :sierra
    sha256 "27506d45e11a7da5c9555cb17318cf99802d5a8749ad17ed66b7a4b1465790cd" => :el_capitan
    sha256 "f14681110117c1762ef909dc0b282bb4c23f298c92eefe20d77fab0199cadbaa" => :yosemite
    sha256 "17abc15792bc75fa186c6748f1cb666814334b2cfec11d708bb9431846746809" => :mavericks
  end

  def install
    system "make"
    bin.install "mp3gain"
  end
end
