class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "http://gtk-gnutella.sourceforge.net/en/?page=news"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.9/gtk-gnutella-1.1.9.tar.bz2"
  sha256 "3b2e913969834a57edd93d22733646037b2a141172d5d4a240f5d6a9f56b6aff"

  bottle do
    sha256 "39fc56e5cc07dab27ce43cbb2a76b739fce8dc77cf6b1b1ad11e43c8440fd3ee" => :el_capitan
    sha256 "b27528d9c646f6fb7dcb41a18be6373869c1b01d759395a9500caabd817b84cf" => :yosemite
    sha256 "a3eaf5073eec90b317502964b01dbf0a22d41b228045ca02714ccc24c59b9ccf" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.deparallelize

    system "./build.sh", "--prefix=#{prefix}", "--disable-nls"
    system "make", "install"
    rm_rf share/"pixmaps"
    rm_rf share/"applications"
  end

  test do
    system "#{bin}/gtk-gnutella", "--version"
  end
end
