class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.2.2/gtk-gnutella-1.2.2.tar.xz"
  sha256 "95a5d86878f6599df649b95db126bd72b9e0cecadb96f41acf8fdcc619771eb6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "7ee623e147c60e1b63884efc6c896eb8d96f3aa7e6efd2b3420ccc8e62c3a970"
    sha256 arm64_big_sur:  "98aa9cfd5659dfa91fef5339e478925ebe373effba12029ec043b3e560b42f39"
    sha256 monterey:       "c0e426bf82a42fcf11ee38d37a154afc6f3317adc3a392c63127d406ba95a2ab"
    sha256 big_sur:        "2ae7a1fadb8b12cd84d511c9a638b87af3c60e3ec1a7a3018b2a5734d70f8431"
    sha256 catalina:       "22e50581e33db28747e0b19e1e96b93b8d8ca97c9c66361b14eed10caae0735b"
    sha256 mojave:         "e886bafacfe443cdf8084edeea890c26a58cf7a63733bb1541eb69745d9b5bf5"
    sha256 x86_64_linux:   "6d1a4d0092864577bb73fa58361bfbc3acdcd0449566403c4f3eb1474229f583"
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
