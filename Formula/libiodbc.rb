class Libiodbc < Formula
  desc "Database connectivity layer based on ODBC. (alternative to unixodbc)"
  homepage "http://www.iodbc.org/dataspace/iodbc/wiki/iODBC/"
  url "https://github.com/openlink/iODBC/archive/v3.52.13.tar.gz"
  sha256 "4bf67fc6d4d237a4db19b292b5dd255ee09a0b2daa4e4058cf3a918bc5102135"

  bottle do
    cellar :any
    sha256 "004fa7bfa6e2abb79b0ad623344aeede05932c18d65820b1c1c84069f6368fe0" => :mojave
    sha256 "8255e22ddcb97db352f37a8be775eb40d120b6a89b724bd461e5d76bbc746c18" => :high_sierra
    sha256 "197ddbad1eec2fc783faf97622dd53cc29c600b0c725fb96b6252dc94dabd731" => :sierra
    sha256 "85570401135c9fa3f6325ae4ce098180128491c4472155f85ad5b7c4c6473d9e" => :el_capitan
    sha256 "cbcd0d50f16a1faa596466ba6678529550d631f770f84657da877f87e17b0424" => :yosemite
    sha256 "47fecc486608df1edc094742a3afbd33c7159c8957429528e11a6fb6f551ebc4" => :mavericks
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
