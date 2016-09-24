class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "http://www.ntop.org/products/ntop/"
  revision 1

  stable do
    url "https://github.com/ntop/ntopng/archive/2.4.tar.gz"
    sha256 "86f8ed46983f46bcd931304d3d992fc1af572b11e461ab9fb4f0f472429bd5dd"

    resource "nDPI" do
      # tip of 1.8-stable branch; four commits beyond the 1.8 tag
      url "https://github.com/ntop/nDPI.git",
        :revision => "6fb81f146e2542cfbf7fab7d53678339c7747b35"
    end
  end

  bottle do
    sha256 "1fc7e9e953d8f56e76be90b02b3d45e91cd2a9bb398a6635a992c733574e6058" => :el_capitan
    sha256 "22821f8c3b10ebab568755a86349ed0a65a28ea04f262df94771e71b8f423502" => :yosemite
    sha256 "156d8545cc8632d4ecb92d2cea86f784da0150f0cd9e0a567985ba9785b1ae1f" => :mavericks
  end

  head do
    url "https://github.com/ntop/ntopng.git", :branch => "dev"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", :branch => "dev"
    end
  end

  option "with-mariadb", "Build with mariadb support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-glib" => :build
  depends_on "wget" => :build
  depends_on "zeromq" => :build
  depends_on "gnutls" => :build

  depends_on "json-c"
  depends_on "rrdtool"
  depends_on "luajit"
  depends_on "geoip"
  depends_on "redis"
  depends_on "mysql" if build.without? "mariadb"
  depends_on "mariadb" => :optional

  def install
    resource("nDPI").stage do
      system "./autogen.sh"
      system "make"
      (buildpath/"nDPI").install Dir["*"]
    end
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ntopng", "-h"
  end
end
