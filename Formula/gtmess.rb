class Gtmess < Formula
  desc "Console MSN messenger client"
  homepage "https://gtmess.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gtmess/gtmess/0.97/gtmess-0.97.tar.gz"
  sha256 "606379bb06fa70196e5336cbd421a69d7ebb4b27f93aa1dfd23a6420b3c6f5c6"
  revision 2

  bottle do
    sha256 "1b9066159f2dbd90cb0ef92ac93a27b5a7e165100a7cbb1cb27e691eefbe409a" => :mojave
    sha256 "534bb2994bffd6e852a0219999ed41286a042f739ce6664bbf1748f369606094" => :high_sierra
    sha256 "40b3eaee60f25bfcc08c6f6c613fa20c3498b471915712c096513b06895710c8" => :sierra
    sha256 "4e13b036917a9a793db1feaf3a3b79b4815f75ed4924963c8cc0ef8a114ced1d" => :el_capitan
    sha256 "a9afe5b901bd068aa32834df9eca85e3f63ef510ecbb8854cd8bdc8e1b6eb66d" => :yosemite
    sha256 "894f4d6e076d77a83aaeb05d6eac7f21551f7de9864b391aaf710613693bdb1c" => :mavericks
  end

  head do
    url "https://github.com/geotz/gtmess.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gtmess", "--version"
  end
end
