class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/3.2.0.tar.gz"
  sha256 "6aecd51c165a36692b4f6481b3071ab936aafc3fccffabbbfda140567f16431d"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "360034118a2b6212bfca66d4e182efd4b3e5deab2c4c444cf53e4fba2174e0ec" => :sierra
    sha256 "720ca014c10c3b98e8146b3f2a42358e1e243008a9cca41763b2816611d3abd6" => :el_capitan
    sha256 "720ca014c10c3b98e8146b3f2a42358e1e243008a9cca41763b2816611d3abd6" => :yosemite
  end

  depends_on "screenresolution" => :recommended
  depends_on "imagemagick" => :recommended

  def install
    inreplace "Makefile", "$(DESTDIR)/etc", "$(DESTDIR)$(SYSCONFDIR)"
    system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}"
  end

  test do
    system "#{bin}/neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end
