class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftp.gnu.org/gnu/libidn/libidn-1.35.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn-1.35.tar.gz"
  sha256 "f11af1005b46b7b15d057d7f107315a1ad46935c7fcdf243c16e46ec14f0fe1e"

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
