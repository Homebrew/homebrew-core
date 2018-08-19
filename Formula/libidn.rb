class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftp.gnu.org/gnu/libidn/libidn-1.35.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn-1.35.tar.gz"
  sha256 "f11af1005b46b7b15d057d7f107315a1ad46935c7fcdf243c16e46ec14f0fe1e"

  bottle do
    cellar :any
    sha256 "d3741facdecc039b53d64392b6f8f4377a01d38bd0ce388db1d4d3606c7d5da9" => :mojave
    sha256 "94e508f0b66a0c37c7a05dad6fff49542439a05cf913980caff4142e58ae998f" => :high_sierra
    sha256 "ddbdf99759b5bf8840afdf4b50de61b3770fab70d26e08c0cd54c8df54c7da7d" => :sierra
    sha256 "11f95f7689146cda4ee3960295cd39f9ec5c613871e35c27d0260c7bd8eeb199" => :el_capitan
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
