class Mp3splt < Formula
  desc "Command-line interface to split MP3 and Ogg Vorbis files"
  homepage "https://mp3splt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3splt/mp3splt/2.6.2/mp3splt-2.6.2.tar.gz"
  sha256 "3ec32b10ddd8bb11af987b8cd1c76382c48d265d0ffda53041d9aceb1f103baa"

  bottle do
    sha256 "9ab7a7f86c461a9e62582a1cee6a598f99ebea011183a1aa765df5453042aabd" => :mojave
    sha256 "a5092d6dcce0af01d4a8194b29180b952350b4ddc3eaf15bfa87441280024c2b" => :high_sierra
    sha256 "0a7e1ba09731532a013aa745232b345844876c3b707f91a359a0a4d5b2fe8773" => :sierra
    sha256 "224f3690f93662a948b257c0129244fcb5f5127647efa31b63cc6d84b2c4bda9" => :el_capitan
    sha256 "d30a89754b5e57a5fd0fff9f794e14ddd920d8f1169158d166e8cd427f85dcd1" => :yosemite
    sha256 "d928c6cc582737877a1e6a1e074f1d9577595eac6ac4a0b52f533141f0e2c4af" => :mavericks
    sha256 "acc0022ebbe437c18d4f3dfca1805a459081288f437101e1cd329a31ca81e522" => :mountain_lion
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
