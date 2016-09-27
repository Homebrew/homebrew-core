class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "http://gtk-gnutella.sourceforge.net/en/?page=news"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.10/gtk-gnutella-1.1.10.tar.bz2"
  sha256 "95e2a030124e7cc05e19e351eebc16f40f4520381b7bb306e8b940ed4e2e6409"

  bottle do
    sha256 "0659488d3cf0641f50f490d4f44c139bf5cd1b0fb69bedc2ab760b6ef41a58d4" => :sierra
    sha256 "412d316f823e2dacdcd5165b7db70f2a308fa1d3fe849860acb264d2afbe8b27" => :el_capitan
    sha256 "9177734b37dc0874f2b6cb8cb4839be9bce2545da8f8dcfe8719924ebcc365e5" => :yosemite
    sha256 "227d5319c74e58b2bfdea1ba95ad768f7a4ef728c1bfbc8f9af728000c9c0d86" => :mavericks
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
