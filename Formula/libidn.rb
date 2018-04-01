class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftp.gnu.org/gnu/libidn/libidn-1.34.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn-1.34.tar.gz"
  sha256 "3719e2975f2fb28605df3479c380af2cf4ab4e919e1506527e4c7670afff6e3c"

  bottle do
    cellar :any
    sha256 "43e9d1a69fe657db90d2aaf5f191741fb3ed428071abbc58d29276cfe5c4c252" => :high_sierra
    sha256 "5e447cc6fb5add5b30907b45a69f017be7daca6f515a2b7bb8338e0323238d60" => :sierra
    sha256 "94571f7decc615e95aa80762956206619785ed44e69a39261ff601f06890521f" => :el_capitan
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
