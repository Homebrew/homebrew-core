class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.2.0/gtk-gnutella-1.2.0.tar.xz"
  sha256 "9608f28706f75423ac6b0d8f260506f1cf0f345a6f04de7cac1232b2504d94c9"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "65fe3df74ec576a933c4aa3576b7cf387e09f1d1757b45e835a1daa326dd4df4" => :big_sur
    sha256 "0c52c25d2374166f992060c2975b920cd37d4a258de01e391102765c286009fb" => :arm64_big_sur
    sha256 "88c016e26d7b8d48bb7f1be67c5b84fadc6af0c58f3d258928f3d7a62c4d7e57" => :catalina
    sha256 "573fef65f5e1766416cfd94f715e2bffe39c6adf3108232d0f80fe76b0711348" => :mojave
    sha256 "c270c4e7d01b10b80a0dac8fc0b91981769c77186f975c5d1ba69a772aae6470" => :high_sierra
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
