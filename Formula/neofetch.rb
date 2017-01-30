class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/3.0.1.tar.gz"
  sha256 "31447da6507c13c44eb2006901c00ed4ca08f0423d9439aaddea64edcaca2c38"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d76acad31a6c94dc33602133fda65a1968b8403b5a42cb2cff96927137008b9d" => :sierra
    sha256 "d76acad31a6c94dc33602133fda65a1968b8403b5a42cb2cff96927137008b9d" => :el_capitan
    sha256 "d76acad31a6c94dc33602133fda65a1968b8403b5a42cb2cff96927137008b9d" => :yosemite
  end

  depends_on "screenresolution" => :recommended
  depends_on "imagemagick" => :recommended

  def install
    inreplace "Makefile", "$(DESTDIR)/etc", "$(DESTDIR)$(SYSCONFDIR)"
    system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}"
  end

  test do
    system "#{bin}/neofetch", "--test", "--config off"
  end
end
