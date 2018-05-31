class Mp3gain < Formula
  desc "Lossless mp3 normalizer with statistical analysis"
  homepage "https://mp3gain.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3gain/mp3gain/1.6.2/mp3gain-1_6_2-src.zip"
  version "1.6.2"
  sha256 "5cc04732ef32850d5878b28fbd8b85798d979a025990654aceeaa379bcc9596d"

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

  test do
    system "#{bin}/mp3gain", "-v"
  end
end
