class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.10.3.tar.gz"
  sha256 "135e18a6bd4568fc9e58a02dbd8b18a31a8bf598bdeaf24795d7d2492c4ad5be"
  head "https://github.com/theZiz/aha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56cfd33659adb98e630ead8d9cff6b3345a7f0a0da484a0921827ff1dcacf9c2" => :sierra
    sha256 "f553081042955aa96a1fa42fcd7572a17357a0986a8f8a9dfb1799fec0f489c1" => :el_capitan
    sha256 "efb7f763bae069d24fdc77942c06cc2267f7b3775b2e6cdf2863ba230dd8350a" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
