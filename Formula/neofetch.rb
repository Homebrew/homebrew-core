class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/3.1.0.tar.gz"
  sha256 "db7afe24d859b9c8230c3491640d996701816ddc9cf66f98a5071775e8b4ffe5"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad666ee43e276045129930e59927db94e2668a6fd5b90d31bad63610da9076ea" => :sierra
    sha256 "6c0fd2ed188d45f036fab1aaa08200c1341406e3ed7093653bf8d574dc90c40a" => :el_capitan
    sha256 "ad666ee43e276045129930e59927db94e2668a6fd5b90d31bad63610da9076ea" => :yosemite
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
