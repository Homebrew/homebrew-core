class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftp.gnu.org/gnu/libidn/libidn-1.36.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn-1.36.tar.gz"
  sha256 "14b67108344d81ba844631640df77c9071d9fb0659b080326ff5424e86b14038"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "86c6d6ed8d6ad080f9174997ffa8f37196a33d84ea914a6e11654560cc1475b0" => :big_sur
    sha256 "c0e93aac7cc1cc6dd1f7a99157e1713d8a05ecead8c8522fbcb631658577fc64" => :arm64_big_sur
    sha256 "1c1767101241edbd4141dc100e1c715b021be85e3fcf3657ea3bbdcb1fa884ec" => :catalina
    sha256 "61e978964009ca11bb25bb366f47872b306a54bbec468f0eca4924a8155bc8a4" => :mojave
    sha256 "306d665a4722e8c32da822c5185eba3abfa2ca0f0624e67e28549c44fb83f9f4" => :high_sierra
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
