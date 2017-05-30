class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "http://tools.suckless.org/dmenu/"
  url "http://dl.suckless.org/tools/dmenu-4.7.tar.gz"
  sha256 "a75635f8dc2cbc280deecb906ad9b7594c5c31620e4a01ba30dc83984881f7b9"

  head "http://git.suckless.org/dmenu/", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "a9b0c177c36f006f820ac7a673f21b6d4e63fcb71d9e2a685346ac98464cebcb" => :sierra
    sha256 "dbc4f0dead6c3fae5245b6771f5196130dd5768a862db89932ea258c849f338f" => :el_capitan
    sha256 "5ab9424eb602d93e02afd71e2206cadbdcc6be985251881cc214468741544826" => :yosemite
  end

  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/dmenu -v")
  end
end
