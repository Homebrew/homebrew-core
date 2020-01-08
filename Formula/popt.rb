class Popt < Formula
  desc "Library like getopt(3) with a number of enhancements"
  homepage "https://web.archive.org/web/20190425081726/rpm5.org/"
  url "https://web.archive.org/web/20170922140539/rpm5.org/files/popt/popt-1.16.tar.gz"
  mirror "https://ftp.openbsd.org/pub/OpenBSD/distfiles/popt-1.16.tar.gz"
  sha256 "e728ed296fe9f069a0e005003c3d6b2dde3d9cad453422a10d6558616d304cc8"

  bottle do
    cellar :any
    rebuild 2
    sha256 "23f177b2638e756dd47d53b25ea1e55d3de5dff01c111287992634624501052d" => :catalina
    sha256 "8df86bf6b02122bdb415a4846974efdaf4a70d9a458d641b0272605950dfcfa9" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
