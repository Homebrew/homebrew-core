class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.14/gtk-gnutella-1.1.14.tar.xz"
  sha256 "31eeaf02ae989aa81791af9f6b4aa3c26c39adc58605dc430edf59451494926a"

  bottle do
    sha256 "082534310bc4f0dde9353a8516a157287c32004c4ad1547dc2b80d58a293ebcd" => :mojave
    sha256 "527cf02632a72b0c51e7bde344400b4574501c93c2458fbcad377ba302de5320" => :high_sierra
    sha256 "feb741e63ae915a2090ac4d9b4c86d88830ba9f1ad9161ac39dc74febe55ce1d" => :sierra
    sha256 "b9d26ca2b07e1195c304a6a0c62ea06325b1831beb367bf6ed20b066a2897c02" => :el_capitan
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
