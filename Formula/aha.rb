class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.5.tar.gz"
  sha256 "6f8b044bee9760a1a85dffbc362e532d7dd91bb20b7ed4f241ff1119ad74758f"
  head "https://github.com/theZiz/aha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a17ea046bebd32238363928f02541965a538909cf66fe6532fc43eb6ca4bffb5" => :mojave
    sha256 "f87de808467a91c6dcaba9b600cadbcd03e309c1b4541278ae11f73c0b402a16" => :high_sierra
    sha256 "9bae4d54f930969df6a87f101d40c061523ee72c6d47b649cb47388c3f3abd5b" => :sierra
    sha256 "9b80c3841426b29cba608e2ee68ed8949920f6af191cd4a0dd6e7a3d356ad310" => :el_capitan
    sha256 "5adf1e9f8d20ffe6f646748f63dca21dcc150d3df2bdff60b97bfb1c4c68bdb4" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
