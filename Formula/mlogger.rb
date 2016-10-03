class Mlogger < Formula
  desc "Log to syslog from the command-line"
  homepage "https://github.com/nbrownus/mlogger"
  url "https://github.com/nbrownus/mlogger/archive/v1.2.0.tar.gz"
  sha256 "141bb9af13a8f0e865c8509ac810c10be4e21f14db5256ef5c7a6731b490bf32"

  bottle do
    cellar :any_skip_relocation
    sha256 "dea257055319fd6917e3ff739afdd2059e85a7c3adfa67aa745dd1d481420a0b" => :sierra
    sha256 "a91ebd8db66c32179a41a6ba9fd595353c19773922ca5a82537926ca17502064" => :el_capitan
    sha256 "876a19cf8c72d8d14e08989d7ace12faac1cb9dad3b7406f37c9fe6370b98924" => :yosemite
    sha256 "3b0249322e3cd31e38b1e040c2fa4bc1aa6500461e7582f06d7260dcce77187a" => :mavericks
    sha256 "dd639c0cfb0e5715082cf744d50121b6e735065ea2216abf299b989646843f64" => :mountain_lion
  end

  def install
    system "make"
    bin.install "mlogger"
  end

  test do
    system "mlogger", "-i", "-d", "test"
  end
end
