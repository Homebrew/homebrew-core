class Advancemame < Formula
  desc "MAME with advanced video support"
  homepage "http://www.advancemame.it/"
  url "https://github.com/amadvance/advancemame/releases/download/v3.2/advancemame-3.2.tar.gz"
  sha256 "7fd10d765cc1ce38bb463bf4c7d5947619bc08838a8671a9f3da0bc6d76eb822"

  bottle do
    sha256 "86ab5b13d3eb63cfdba99b900ee6a80826af8485d0d84b84d21c478689f1a37a" => :sierra
    sha256 "d74ae874ef51579e2bb7468d66d44d6fbcf8e3d74e02d8482458174f2a100958" => :el_capitan
    sha256 "661fadb58b64de9ab525ffb24771639bf7409eb28b1266f49748457ef2df18c7" => :yosemite
  end

  depends_on "sdl"
  depends_on "freetype"

  def install
    ENV.delete "SDKROOT" if MacOS.version == :yosemite
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}", "docdir=#{doc}"
  end

  test do
    system "#{bin}/advmame", "--version"
  end
end
