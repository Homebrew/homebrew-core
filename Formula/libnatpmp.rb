class Libnatpmp < Formula
  desc "NAT port mapping protocol library"
  homepage "http://miniupnp.free.fr/libnatpmp.html"
  url "http://miniupnp.free.fr/files/download.php?file=libnatpmp-20130911.tar.gz"
  sha256 "a30d83b9175585cc0f5bff753ce7eb5d83aaecb6222ccac670ed759fea595d7d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b5311d3a609970d008815a58454500dd753e0900f6dc9e1e57b387aa5f452626" => :sierra
    sha256 "66c86d92e33fe778c8383066070983d44c5d6d8f479d57a6e1e391a52ae21632" => :el_capitan
    sha256 "56614258c625a9f98733b0fe0c451cf62725fd874b413f08e45ed93a8fdaa991" => :yosemite
    sha256 "66441cfb63476b8d74f5b90dccd434b081201cc7e900f7b2da4cba949cf40ef8" => :mavericks
    sha256 "e653484cb16a9732132635cf784bd7096d647277c017318316d8a442b559ca2a" => :mountain_lion
  end

  def install
    # Reported upstream:
    # https://miniupnp.tuxfamily.org/forum/viewtopic.php?t=978
    inreplace "Makefile", "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
