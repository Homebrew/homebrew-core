class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "https://www.musicpd.org/clients/mpc/"
  url "https://www.musicpd.org/download/mpc/0/mpc-0.29.tar.xz"
  sha256 "02f1daec902cb48f8cdaa6fe21c7219f6231b091dddbe437a3a4fb12cb07b9d3"

  bottle do
    cellar :any
    sha256 "0402296ce3f6423ba0611059d6091151fd682d2508abaa17ba06c7e25276fe22" => :high_sierra
    sha256 "aba27710d5d28f11e4df66e31baa307064c3ac6760083b0ee6411a57ff4920c1" => :sierra
    sha256 "c963c018ed6d13b3bd46fd292fa42d29298499b96fc8cb60ae62accb292d6b7a" => :el_capitan
    sha256 "10dbe56eb9a55d841001a9b7b553b80cd7287404b97f8526e2343b66cf6510e6" => :yosemite
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libmpdclient"

  def install
    system "meson", "--prefix=#{prefix}", ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"
  end

  test do
    assert_match "query", shell_output("#{bin}/mpc list 2>&1", 1)
  end
end
