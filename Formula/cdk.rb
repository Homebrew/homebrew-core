class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "http://invisible-island.net/cdk/"
  url "ftp://invisible-island.net/cdk/cdk-5.0-20161210.tgz"
  version "5.0.20161210"
  sha256 "9e7558cb8850ca5c7ab4cc38e0612b0e8c4aad680d2a2511f31d62f239e35fad"

  bottle do
    cellar :any_skip_relocation
    sha256 "71a778e7eec2d2af0dfe1370510306db403d15f0ef43705d8e57b3ecdee4678a" => :sierra
    sha256 "44d59e8d469fb3232f12b8cd3c8c84f2c30fbe874d911403164811b41a77d633" => :el_capitan
    sha256 "308bde479ebe6315c3a5309e12b4606bc36a43719aff815e787a904fabdd5877" => :yosemite
    sha256 "e974e6af5cd57bbab511884ca0c0df82155303d4e94f40d1bcb9aa55a65703c5" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
