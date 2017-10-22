class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.13/gtk-gnutella-1.1.13.tar.xz"
  sha256 "2126cd08941ba0847c06f1034c5e2a9428b67b2fd1685c0e3ab878cb0179f647"

  bottle do
    sha256 "1bbba4fa35a115dc97a8093abfeff1a825438dc5e255da0f4c2427348bb0b9df" => :high_sierra
    sha256 "3e0ef564ff86940fd0b49d9845671a61fa9d8127e698af29308868ae4fa3500c" => :sierra
    sha256 "056dba8d778c10fd91b1ecb1695235ec6f7303f34e970e1035e304ddcfc0e561" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.deparallelize

    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "Configure", "ret = clock_gettime(CLOCK_REALTIME, &tp);",
                             "ret = undefinedgibberish(CLOCK_REALTIME, &tp);"
    end

    system "./build.sh", "--prefix=#{prefix}", "--disable-nls"
    system "make", "install"
    rm_rf share/"pixmaps"
    rm_rf share/"applications"
  end

  test do
    system "#{bin}/gtk-gnutella", "--version"
  end
end
