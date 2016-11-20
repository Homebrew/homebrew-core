class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.10.3.tar.gz"
  sha256 "135e18a6bd4568fc9e58a02dbd8b18a31a8bf598bdeaf24795d7d2492c4ad5be"
  head "https://github.com/theZiz/aha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5cada08a5d44ec9b8117c630093c6c0fcd9af9d6f00e18e90f49737ff2becdf" => :sierra
    sha256 "284105b95fdba331bcedf225809c3d8d37d595c16bcdac2723453a0657699030" => :el_capitan
    sha256 "dfad261666c610f17e852d93538e7c561abdc5db6eb6bda3c3f078f8b6a09553" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
