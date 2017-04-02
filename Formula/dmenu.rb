class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "http://tools.suckless.org/dmenu/"
  url "http://dl.suckless.org/tools/dmenu-4.6.tar.gz"
  sha256 "4a7a24008a621c3cd656155ad91ab8136db8f0d3b9ec56dafeec518cabda96b3"

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
