class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.12.7.tar.gz"
  sha256 "5d56801bb1f8a3b673409e6960b07c9d8fa05f2315558ac173b80a65c344f3aa"
  revision 1

  bottle do
    cellar :any
    sha256 "5a50c88c8c6e09dc92ad3ae3fa4c81dad74dc30c5ce8a27dd4dc5c2f3f0fa2f5" => :sierra
    sha256 "5a73f91966b9781e1b2124f596b32da837375975314e2a568a3bee2709492b51" => :el_capitan
    sha256 "955b4de3af8fb870a78ecfda131bc31e848adf3249fe89be5b7a5a8c03ffa36c" => :yosemite
  end

  head do
    url "https://github.com/indexdata/pazpar2.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "yaz"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/pazpar2", "-V"
  end
end
