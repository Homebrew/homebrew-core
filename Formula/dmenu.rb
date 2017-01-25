class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "http://tools.suckless.org/dmenu/"
  url "http://dl.suckless.org/tools/dmenu-4.6.tar.gz"
  sha256 "4a7a24008a621c3cd656155ad91ab8136db8f0d3b9ec56dafeec518cabda96b3"

  head "http://git.suckless.org/dmenu/", :using => :git

  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/dmenu -v")
  end
end
