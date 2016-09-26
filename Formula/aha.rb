class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.9.tar.gz"
  sha256 "9aefb7d7838e2061672813482d062ac4c32c932f7f8f0928766ba0152fec3d77"
  head "https://github.com/theZiz/aha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "832319957e6a4ac53e65d124ad40498faa4cf6500e1c4b4593733f15e28b44c6" => :sierra
    sha256 "9f72f7009a073e6aa06ff9ea24535ab0e3230142b7d76a55c7dee633e9d2ddbf" => :el_capitan
    sha256 "88c6950fd5667f3f4df808dd77aa85aa8af353594ab051c50345a31bf33340ca" => :yosemite
    sha256 "07a3cdeb8869ec4aecef71b83ccca863e626a05cf3ed9cb614acb1a007c1a365" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
