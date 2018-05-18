class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/4.0.1.tar.gz"
  sha256 "a227e296547846296a19cc483ab6a3af5e3e9f2c2eba4563d060bad2c50f4fab"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00c1aabbb1937b49bce45e218fcf3a30a1a073db401b007529a34d8515bbf5ef" => :high_sierra
    sha256 "00c1aabbb1937b49bce45e218fcf3a30a1a073db401b007529a34d8515bbf5ef" => :sierra
    sha256 "00c1aabbb1937b49bce45e218fcf3a30a1a073db401b007529a34d8515bbf5ef" => :el_capitan
  end

  depends_on "screenresolution" => :recommended
  depends_on "imagemagick" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end
