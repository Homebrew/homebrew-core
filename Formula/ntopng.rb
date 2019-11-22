class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  revision 1

  stable do
    url "https://github.com/ntop/ntopng/archive/3.8.tar.gz"
    sha256 "683d28aece3bf3f17c3d53d7a76fbd2a24719767477f5dce55268683fd87f821"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI/archive/2.6.tar.gz"
      sha256 "efdfb68940385b18079920330528978765dc2a90c8163d10f63301bddadbf91e"
    end
  end

  bottle do
    sha256 "3a602d61daeaefb049709098a3d242c1ac2ad5afb4f77be8a4ddbf93da664b95" => :catalina
    sha256 "6cb5cc074b9ea01ad835bd886db85ae9e9b1df171ed61958533dd117a0e7be94" => :mojave
    sha256 "69641c0b78b4e5d642ae7410d2859f501434d25b8064d33dcb46156520432a7c" => :high_sierra
  end

  head do
    url "https://github.com/ntop/ntopng.git", :branch => "dev"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", :branch => "dev"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnutls" => :build
  depends_on "json-glib" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "zeromq" => :build
  depends_on "geoip"
  depends_on "json-c"
  depends_on "libmaxminddb"
  depends_on "lua"
  depends_on "mysql-client"
  depends_on "redis"
  depends_on "rrdtool"

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
    system "#{bin}/ntopng", "-V"
  end
end
