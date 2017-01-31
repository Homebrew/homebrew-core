class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/3.0.tar.gz"
  sha256 "b5d3319474ff432c874dd39d38800ac8eb31da0b8e481b871ff4792f07fb67c4"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d76acad31a6c94dc33602133fda65a1968b8403b5a42cb2cff96927137008b9d" => :sierra
    sha256 "d76acad31a6c94dc33602133fda65a1968b8403b5a42cb2cff96927137008b9d" => :el_capitan
    sha256 "d76acad31a6c94dc33602133fda65a1968b8403b5a42cb2cff96927137008b9d" => :yosemite
  end

  # Fixes config file detection now that neofetch stores the config in /usr/local/etc
  # Can be removed with the next release
  patch do
    url "https://github.com/dylanaraps/neofetch/commit/0fed289d58bb5f0675ebed37f5bb71b11ad54b9e.patch"
    sha256 "39dd55b268b515f22521e0dd2f1a31edd0b869cabf4c515142399906d9fa2d6d"
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
