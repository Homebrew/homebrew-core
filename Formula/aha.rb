class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.9.tar.gz"
  sha256 "9aefb7d7838e2061672813482d062ac4c32c932f7f8f0928766ba0152fec3d77"
  head "https://github.com/theZiz/aha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8eece3bfabca1cb0e2f10edab863510595185ee93a96cca84ec30b99a76ff094" => :el_capitan
    sha256 "f780f9cb0af36a42b38791bca79cef0cf1d24d9ba833fbb0e56f0a82edb21997" => :yosemite
    sha256 "42d625a5da619d93696d84ac01cd40c752bf56e0f72c71d2e500339691b1637f" => :mavericks
    sha256 "a64ce01547378269c54d0baeb39ec787e88bc9c161040586763f534a78bef5f6" => :mountain_lion
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
