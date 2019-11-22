class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.15/gtk-gnutella-1.1.15.tar.xz"
  sha256 "2931fab394b6d36c14a6bbc3b0ff584af5550f2eeb03f78bb19743c47767c1b7"

  bottle do
    sha256 "9fb121eec5c3e0f3e8750464148488870056596b59068e5765991c3851e85316" => :catalina
    sha256 "1ab6b18c2ec8cd720a7024e471ceba5b9c8397c8c589b4eebbb371a2dc390f24" => :mojave
    sha256 "dc0cab460a17691ee852300b90f014eeaa7871c59859cf92e887aa882b032ed0" => :high_sierra
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
