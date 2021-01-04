class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.4.1.tar.gz"
  sha256 "8c535d48120b08df1731de709f2dbd2ba8bce568ad64cac34826102caf594d84"
  license "LGPL-3.0-only"

  livecheck do
    url "https://tools.netsa.cert.org/fixbuf/download.html"
    regex(%r{releases/libfixbuf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "085adc7203ce2622842c3bf16784de83a77e0f3bc0a3295a48d952ad4c9beb58" => :big_sur
    sha256 "b7d61c0a90e2e9f9640ab8f25f4ba553fa3691336cd43a79d4688b79df843621" => :arm64_big_sur
    sha256 "39eac22cafeaa515259fe5b8ddd635b98c69ca42699107bd05e5560d285f6724" => :catalina
    sha256 "5c63110b498601708f2669fa1c5c734a4d8d67abbdfdfd5056255c746ef6e6ee" => :mojave
    sha256 "d76d8050c0355326777460e738008b3820b39c53ec38ee759c0c8ddacf0c090e" => :high_sierra
  end

  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
