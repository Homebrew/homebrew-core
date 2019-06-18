class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.14/gtk-gnutella-1.1.14.tar.xz"
  sha256 "31eeaf02ae989aa81791af9f6b4aa3c26c39adc58605dc430edf59451494926a"
  revision 1

  bottle do
    sha256 "1414404b1a91d09a17d64f12382d4a0ce71a06081322eb27afb05ab9fa58f07e" => :mojave
    sha256 "42bbb5ab94942025676daee8c9be4b140eb1a324e96330f992bfdf7473db8eec" => :high_sierra
    sha256 "61f53035fe11324c64b19410dca984bedfea8874dcf931422aa4c6c66b437b0b" => :sierra
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
