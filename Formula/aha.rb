class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.10.1.tar.gz"
  sha256 "afcb7be593c80977c891b13bb6d44e924c84ff0167645ddd533adf705f799463"
  head "https://github.com/theZiz/aha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65839d85080408fbfe38d16ce85c471e3e7dd2cfd7be888d35a4390826ce86b4" => :sierra
    sha256 "d1ac40755aaed2521c239b46bd5029b413b07211a135fb30a35bec3ba911c473" => :el_capitan
    sha256 "db9ce0f98956d01574f2dcb7a6e48d2aa7fac39eaff5ac4bcdca768cbbcffeb1" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
