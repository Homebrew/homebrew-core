class Mp3gain < Formula
  desc "Lossless mp3 normalizer with statistical analysis"
  homepage "https://mp3gain.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3gain/mp3gain/1.6.1/mp3gain-1_6_1-src.zip"
  version "1.6.1"
  sha256 "552e77f9333a04f35d68808565ec99b5eb6707985ea946f60f13c81a42daf25d"

  bottle do
    cellar :any
    sha256 "98b7ecffc65da0e71336ad8245194a53efc35f5a6800e6e150a4a5c71a064fc7" => :high_sierra
    sha256 "614b1a01ffe49eb9efefa7a67d96be47ada351435518313ff0c5607e9fa41b15" => :sierra
    sha256 "4c33387aa252d25779c2c0d15dee99fee03873f73a65200d2e69d74f0df48158" => :el_capitan
  end

  depends_on "mpg123"

  def install
    system "make"
    bin.install "mp3gain"
  end
end
