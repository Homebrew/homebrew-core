class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "https://tools.suckless.org/dmenu/"
  url "https://dl.suckless.org/tools/dmenu-4.8.tar.gz"
  sha256 "fe615a5c3607061e2106700862e82ac62a9fa1e6a7ac3d616a9c76106476db61"

  head "https://git.suckless.org/dmenu/", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "1f81d44aa27e4059f2bef9c768b6875c1f1ed3f462ad7582df976f5c50b518f2" => :high_sierra
    sha256 "2ef9de864fabaaae5e7214658d0bae190e0e895353fccbb5cdebc2a94f22306f" => :sierra
    sha256 "0c2038a9f53d43a393d6108f49465fb095f2854d4f31acb777645018d84a6cd8" => :el_capitan
    sha256 "75598d67eac5f745e325ae0f0f5eed063873f92bbd64c02126cf2ea95682c2c3" => :yosemite
  end

  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/dmenu -v")
  end
end
