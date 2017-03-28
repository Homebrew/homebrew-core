class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.10.6.tar.gz"
  sha256 "747e939787dca7a9620869fefc17b60f5e29f0ea3965548d15dc9b2a1f31c3f6"
  head "https://github.com/theZiz/aha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e6989b80fac995c3fb41edab81c3578daa96bbd8b264d6d76b2300c8e4bb1c7" => :sierra
    sha256 "7b967f8817cc0e4de348aaa37f67f91a1a652256b0eca0cf349c4a746e669d0b" => :el_capitan
    sha256 "edc535121189e9ba0deb86b0f3828b9478fcf52c7dbdaac7601499b07f9a43e2" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
