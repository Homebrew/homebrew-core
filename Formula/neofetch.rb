class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/4.0.1.tar.gz"
  sha256 "a227e296547846296a19cc483ab6a3af5e3e9f2c2eba4563d060bad2c50f4fab"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3285653664fe6c994593df9de4957e044e3407478b4b6887072f4107e341941a" => :high_sierra
    sha256 "3285653664fe6c994593df9de4957e044e3407478b4b6887072f4107e341941a" => :sierra
    sha256 "3285653664fe6c994593df9de4957e044e3407478b4b6887072f4107e341941a" => :el_capitan
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
