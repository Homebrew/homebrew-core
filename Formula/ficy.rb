class Ficy < Formula
  desc "Icecast/Shoutcast stream grabber suite"
  homepage "https://www.thregr.org/~wavexx/software/fIcy/"
  url "https://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.21.tar.gz"
  sha256 "8564b16d3a52fa6dc286b02bfcc19e4acdc148c30f1750ca144e2ea47c84fd81"
  head "https://github.com/wavexx/fIcy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe5ec58f592b05a79f1a1f867ceedf29b342c10659bb9167cef924ddc9260d72" => :mojave
    sha256 "a47243a3eddfb8b8aa8ddb337de2ec09b80385bcdf6922a858a50d4a5d79cc47" => :high_sierra
    sha256 "c8e04a4eb2cf74a46ed02c14c18bb13b06dcdc8703f5913744e904492efe64d8" => :sierra
    sha256 "b3230fe854623e9ef87868b028a7c3cdfa7b08cdd749def59312cbc47c510bec" => :el_capitan
    sha256 "ba35c8e07903b74a37daf9131f26a578320f79252aa95e9ca7a5921065cd2a51" => :yosemite
  end

  def install
    system "make"
    bin.install "fIcy", "fPls", "fResync"
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    system "#{bin}/fResync", "-n", "1", "test.mp3"
  end
end
