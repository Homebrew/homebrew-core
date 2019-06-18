class Mp3splt < Formula
  desc "Command-line interface to split MP3 and Ogg Vorbis files"
  homepage "https://mp3splt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3splt/mp3splt/2.6.2/mp3splt-2.6.2.tar.gz"
  sha256 "3ec32b10ddd8bb11af987b8cd1c76382c48d265d0ffda53041d9aceb1f103baa"
  revision 1

  bottle do
    sha256 "fb9ec207370028ac673f0f4e067dbae93d19e567ca80ab46e9e49d895262ac81" => :mojave
    sha256 "5dac4b6a6632c234ad5137084275924e1fcc32833a333924cc55fc50da51afe3" => :high_sierra
    sha256 "86a18b472c2b9a7b603da79caa1e406c3ca73d717a508cf6999ae2c73a6b7870" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libmp3splt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mp3splt", "-t", "0.1", test_fixtures("test.mp3")
  end
end
