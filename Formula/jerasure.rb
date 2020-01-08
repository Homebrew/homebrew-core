class Jerasure < Formula
  desc "Library in C that supports erasure coding in storage applications"
  homepage "http://jerasure.org/"
  url "https://bitbucket.org/tsg-/jerasure/get/v2.0.0.tar.bz2"
  sha256 "f736646c1844c4e50dfe41ebd63c7d7b30c6e66a4aa7d3beea244871b0e43b9d"
  revision 1

  bottle do
    cellar :any
    sha256 "9e653391281dc30c18579c7a6158744a025a9aab8861454bafe221ebfc652c0b" => :catalina
    sha256 "1ae9b78eb70cf790c5a2e182508487746b3008ef9b0727b377cb3fd01faa8e29" => :mojave
    sha256 "8e63bf431836395466d91ef947126a39c8193b274ab22156cf421d6958508607" => :high_sierra
    sha256 "603646521f0255877f611df53e30ccbc071b07cba6e0f33025404332e9677ffa" => :sierra
    sha256 "1db6ef4631512bf3b155d614588689b2bacc911178cedf828db8f810d9e18d43" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gf-complete"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"jerasure_01", "2", "5", "3"
  end
end
