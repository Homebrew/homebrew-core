class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/3.0.tar.gz"
  sha256 "b5d3319474ff432c874dd39d38800ac8eb31da0b8e481b871ff4792f07fb67c4"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb072d134f876ab2a8d37713673b9099d33f5b5b7ec5276b42d51edb6da72a35" => :sierra
    sha256 "efb18f551826ff73ead2537b13cf94bfbbbdf680fab6dae58da75f22584528f5" => :el_capitan
    sha256 "bb072d134f876ab2a8d37713673b9099d33f5b5b7ec5276b42d51edb6da72a35" => :yosemite
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
