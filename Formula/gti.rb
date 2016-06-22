class Gti < Formula
  desc "ASCII-art displaying typo-corrector for commands"
  homepage "http://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/v1.3.0.tar.gz"
  sha256 "f344b9af622980e3689d3bc7866a913c6794ff5c22b09fa92e2b684309aba958"

  head "https://github.com/rwos/gti.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2dc006bbf70e86ba6a4535d20eb5c6d8a25685f2a5c7ce4f87bfbfef1097443" => :el_capitan
    sha256 "12a2fcc7465f9fba5cdaa92ea0af3e5ef459f42b4c5c930017fef0fb3366f121" => :yosemite
    sha256 "308b88323f417d45c627add34f7b74b9f63cbc3f3065b3b3909908a3b78769cf" => :mavericks
    sha256 "2e19e781ff48dee619cadbda1937d7a7a295ddbaa29af4b8881d211ea27b0c57" => :mountain_lion
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"
  end

  test do
    system "#{bin}/gti", "init"
  end
end
