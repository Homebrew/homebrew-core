class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.14/gtk-gnutella-1.1.14.tar.xz"
  sha256 "31eeaf02ae989aa81791af9f6b4aa3c26c39adc58605dc430edf59451494926a"

  bottle do
    sha256 "66c1799f73b1edfaea5d5b0947a464cdefce1c8fa279e2442a4ad8800da41236" => :mojave
    sha256 "14bc32efbbb688ec25578bee79f8b76e9bc78df6b5b3755bd5b2c7d7436447f3" => :high_sierra
    sha256 "2fa0fdbaaad5549074b6642dbb30e27fe59a465f26cbdb3319b20e76cc7e7dc5" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.deparallelize

    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
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
