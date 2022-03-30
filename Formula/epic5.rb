class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.7.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.7.tar.xz"
  sha256 "71627b14e26390f1e216047f40ca5ee1e7d55651667787466433bf7abdb6e317"
  license "BSD-3-Clause"
  head "http://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6e1ce5354ed3d4db90bf4fcb967efc260759698bddfc3efff61496482ba66f63"
    sha256 arm64_big_sur:  "36abf84918060064f79935e49bcaad31e2c9c835eece141c757e0399c66a489a"
    sha256 monterey:       "7e284146e725708f61b7cf3a11687036ed88e00c03256c247295204ceb50890f"
    sha256 big_sur:        "a2949e863afccbf53fd8de505c4a4b06651f56b003fc1592cc3d72227aa5f3eb"
    sha256 catalina:       "7ab5e04e421d2d435680540de8dcd2268adf3de9612fa9dc47b9c1075c6c5c81"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-ipv6",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    connection = fork do
      exec bin/"epic5", "irc.freenode.net"
    end
    sleep 5
    Process.kill("TERM", connection)
  end
end
