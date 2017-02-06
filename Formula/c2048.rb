class C2048 < Formula
  desc "Console version of 2048"
  homepage "https://github.com/mevdschee/2048.c"
  url "https://github.com/mevdschee/2048.c.git", :revision => "578a5f314e1ce31b57e645a8c0a2c9d9d5539cde"
  version "0+20150805"
  head "https://github.com/mevdschee/2048.c.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "150f562e3a85e962e576fe172353fc709483cb9b49f47dd05b0248fb0b238f0e" => :el_capitan
    sha256 "aedb7caed6f1bfeb343a12df5cb62b060a92cbfb27f22af6d4aede12968d92c2" => :yosemite
    sha256 "bfee60cbfe49b6f5b4a4dc14f6f83a7e521f7c5fe651dd701307dd185de798e5" => :mavericks
  end

  def install
    system "make"
    bin.install "2048"
  end

  def caveats; <<-EOS.undent
    The game supports different color schemes.
    For the black-to white:
      2048 blackwhite
    For the blue-to-red:
      2048 bluered
    EOS
  end

  test do
    system "#{bin}/2048", "test"
  end
end
