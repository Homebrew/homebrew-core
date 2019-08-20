class Libiodbc < Formula
  desc "Database connectivity layer based on ODBC. (alternative to unixodbc)"
  homepage "http://www.iodbc.org/dataspace/iodbc/wiki/iODBC/"
  url "https://github.com/openlink/iODBC/archive/v3.52.13.tar.gz"
  sha256 "4bf67fc6d4d237a4db19b292b5dd255ee09a0b2daa4e4058cf3a918bc5102135"

  bottle do
    cellar :any
    sha256 "1472bb0987705537158b7c3196d27d01ba02d6c0fdcca733f3cf8d53eca29c5d" => :mojave
    sha256 "77a4fb5fa3036a831e05e2a83585ac2fcdcdf4cf83baa72f28cfb2f8a659ba13" => :high_sierra
    sha256 "abc07f2fe98ed04c4dc5bd5cada2ea68fb9be56337ed442393609f0a22ec21e8" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  conflicts_with "unixodbc", :because => "both install 'odbcinst.h' header"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iodbc-config", "--version"
  end
end
