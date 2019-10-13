class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.5.tar.gz"
  sha256 "6f8b044bee9760a1a85dffbc362e532d7dd91bb20b7ed4f241ff1119ad74758f"
  head "https://github.com/theZiz/aha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6492a70a68055bd7034820fc1a8dd951797ebde44515ffcd9d4416da732eeeb6" => :catalina
    sha256 "b22a64305a6e2b05dfbc534169d4536d34dcb5ed81be53dbf57f7dd640a6b9bf" => :mojave
    sha256 "be1915be3aebd7fdccc3e0d694351b29c9e5af4093492154dbf46ddb5d506a2b" => :high_sierra
    sha256 "2625fabfb62878a3123448e5dbe56e18efbd0d90f1b4dcf3dc1619274ecb7c08" => :sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
