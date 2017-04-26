class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/3.1.0.tar.gz"
  sha256 "db7afe24d859b9c8230c3491640d996701816ddc9cf66f98a5071775e8b4ffe5"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9a5faf466b27025e7a40440ed1e3a093bd4982e14be3b961afcdcf284726659" => :sierra
    sha256 "121cb2952982a2e7a4b2e83b718ccdfbe98f8a76f9927479b66aed2df62ab13f" => :el_capitan
    sha256 "121cb2952982a2e7a4b2e83b718ccdfbe98f8a76f9927479b66aed2df62ab13f" => :yosemite
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
