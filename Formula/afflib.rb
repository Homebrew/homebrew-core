class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.18.tar.gz"
  sha256 "5481cd5d8dbacd39d0c531a68ae8afcca3160c808770d66dcbf5e9b5be3e8199"
  revision 1

  bottle do
    cellar :any
    sha256 "8777c09fb89f6ef70f6324fe9765a2dfc1c3d9a86fcd0b583d9c8f2465be61f1" => :mojave
    sha256 "09d2326ac0d816477129b38f85af29b8f2ab42448b76f603ec77bf8b64aebb24" => :high_sierra
    sha256 "771fa58a6d3470a4a40a64b6c771533e4a5705077d9ea02a006f0d71074892b0" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "python"

  def install
    args = %w[
      --enable-s3
      --enable-python
      --disable-fuse
    ]

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *args
    system "make", "install"
  end

  test do
    system "#{bin}/affcat", "-v"
  end
end
