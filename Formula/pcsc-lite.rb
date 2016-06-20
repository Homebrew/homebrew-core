class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.alioth.debian.org"
  url "https://alioth.debian.org/frs/download.php/file/4173/pcsc-lite-1.8.17.tar.bz2"
  sha256 "d72b6f8654024f2a1d2de70f8f1d39776bd872870a4f453f436fd93d4312026f"

  bottle do
    sha256 "99ef35f4b7028383a1cf034af5aa10003fe1c8d1265ce59dfc057bfb6c3a2970" => :el_capitan
    sha256 "19e90063f303566b5d2d26098a70793f53a0a24e342c628a6a0996dd632f2ae9" => :yosemite
    sha256 "f40222c350abc53f437b928ea8084cc46b57764e933d29a700a203d5f63f5614" => :mavericks
  end

  keg_only :provided_by_osx,
    "pcsc-lite interferes with detection of OS X's PCSC.framework."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
