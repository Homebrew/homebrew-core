class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.26.tar.xz"
  sha256 "8bd2365cac73692ca03166e60bec2113ee00f42a4137e4ab47742452733b0d14"

  bottle do
    sha256 "c4d24c040b851b642342d196a2e5c5a8146a8d6bed68d79d8cfcb7ec2e4699b9" => :sierra
    sha256 "fbc08c275e60e7267c5984995ab80725ffcf46c21ab0725950bd4ebe6ec2f61e" => :el_capitan
    sha256 "ad1fdbc26705129584d628f0c32d8ff527622b7ba19272e107e61d4521818e22" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libmpdclient"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
