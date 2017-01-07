class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "http://gtk-gnutella.sourceforge.net/en/?page=news"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.11/gtk-gnutella-1.1.11.tar.bz2"
  sha256 "e46ffa3905831828f867709aa346cd88576075bd1299ef396962ad860e2589d5"

  bottle do
    sha256 "57b55568dad77dcef085784e3a1da5e3d61131ecf0fa192edcc6945765dbfa26" => :sierra
    sha256 "995fc6e0bd1aa6d1dbae1664f666a41846fba9cb5c3024cfbe257109a5848d4e" => :el_capitan
    sha256 "6bcadba84c5244c0f0620ee7bd92c971559fd4a5b0bdfbe54b8a43495961a4b4" => :yosemite
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
