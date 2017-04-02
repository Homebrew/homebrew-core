class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.10.6.tar.gz"
  sha256 "747e939787dca7a9620869fefc17b60f5e29f0ea3965548d15dc9b2a1f31c3f6"
  head "https://github.com/theZiz/aha.git"

  bottle do
    cellar :any_skip_relocation
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
