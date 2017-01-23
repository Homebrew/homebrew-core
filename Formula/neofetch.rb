class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/3.0.tar.gz"
  sha256 "b5d3319474ff432c874dd39d38800ac8eb31da0b8e481b871ff4792f07fb67c4"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d71c70e67a1d0085b3c41f0e0ef996de97f7ed53eed754a942da7ab888ea3591" => :sierra
    sha256 "34db4e4e0cfe5a096a76e84730b7c1d0f2d0b07e1279a747f79a172af9a0bef7" => :el_capitan
    sha256 "d71c70e67a1d0085b3c41f0e0ef996de97f7ed53eed754a942da7ab888ea3591" => :yosemite
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
