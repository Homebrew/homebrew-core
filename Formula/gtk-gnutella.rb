class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.12/gtk-gnutella-1.1.12.tar.bz2"
  sha256 "ca65f9c56a5e17e6cb84246d5e2db453f1c73863ef937b8a1772ff4572d562ff"

  bottle do
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
