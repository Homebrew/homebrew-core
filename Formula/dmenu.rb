class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "http://tools.suckless.org/dmenu/"
  url "http://dl.suckless.org/tools/dmenu-4.7.tar.gz"
  sha256 "a75635f8dc2cbc280deecb906ad9b7594c5c31620e4a01ba30dc83984881f7b9"

  head "http://git.suckless.org/dmenu/", :using => :git

  bottle do
    cellar :any_skip_relocation
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
