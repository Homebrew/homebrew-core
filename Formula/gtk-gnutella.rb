class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.13/gtk-gnutella-1.1.13.tar.xz"
  sha256 "2126cd08941ba0847c06f1034c5e2a9428b67b2fd1685c0e3ab878cb0179f647"

  bottle do
    sha256 "417164f40527b51744bfd3517e6a315a8f9ba5783fed7c34d0e4d159851a0d1f" => :high_sierra
    sha256 "eefc6bab168821260727a382a006c9c03fed094954f9ae599a89d54e807c64c8" => :sierra
    sha256 "47c5f05d62fa9b7e914d95fd2a38587c483297a78c656e53d35bfb74a94735d5" => :el_capitan
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
