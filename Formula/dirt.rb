class Dirt < Formula
  desc "Experimental sample playback"
  homepage "https://github.com/tidalcycles/Dirt"
  url "https://github.com/tidalcycles/Dirt/archive/1.0.tar.gz"
  sha256 "4a79a3c8650e8852907beb2d40af0f9bc2824adcffc91041fe62edd55c23ecdc"
  head "https://github.com/tidalcycles/Dirt.git"

  bottle do
    cellar :any
    revision 1
    sha256 "69b2cd867f521cb496e5f08a78c6746b9130470799d992120e4a510fcef4f50e" => :el_capitan
    sha256 "48051e60852c03311590435ea1c169eeb731e63d08999247cb1348f6f187b5ee" => :yosemite
    sha256 "d044f78c53c70177327e93f7faa670d7bc66c62b91ecfb710d472385a5a9b4a3" => :mavericks
  end

  depends_on "jack"
  depends_on "liblo"

  def install
    system "make", "DESTDIR=#{prefix}", "install"
  end

  test do
    system "#{bin}/dirt", "-h"
  end
end
