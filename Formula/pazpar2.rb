class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.12.7.tar.gz"
  sha256 "5d56801bb1f8a3b673409e6960b07c9d8fa05f2315558ac173b80a65c344f3aa"
  revision 1

  bottle do
    cellar :any
    sha256 "c6e7964c126bf5a7d7840fa0f835f9c42ae92cfa4273241d8163041ef0b8eca6" => :sierra
    sha256 "4f4d33fdca8f24e2b3f122f825251a7b11354d5b8383ca435aa67f51412cb496" => :el_capitan
    sha256 "d2b3a8c64ae2ecd75708c790e4f67b4cc0309699c3cc5b9d7b02a87db100f45e" => :yosemite
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
