class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.7.1/libmaxminddb-1.7.1.tar.gz"
  sha256 "e8414f0dedcecbc1f6c31cb65cd81650952ab0677a4d8c49cab603b3b8fb083e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7a8bdefbc6e7b19c6704286c71a3f616c98e2d7cb00c0e704083c58216020c6f"
    sha256 cellar: :any,                 arm64_monterey: "f43032f9d2a53d6ab4969fdf90ab9db14ac2d2ea10c4e8b594060ad1d7f01b95"
    sha256 cellar: :any,                 arm64_big_sur:  "d7fdc2b82f0c5af1ec537354b0ef8404edd1d067db901463cfa75a1731fa5839"
    sha256 cellar: :any,                 ventura:        "1987cff883cf2c1b5a683b533800cb384454590b17c657019a58add6b451fa4d"
    sha256 cellar: :any,                 monterey:       "ddda0e691d8e86dded50880d64ebf8ddec4a6d4cd55b1be7f64ac0e3e6fe3c27"
    sha256 cellar: :any,                 big_sur:        "1bae95c9b92e0268300874e89f184a086af2a780a0f3cd7ba8ef968316000d9e"
    sha256 cellar: :any,                 catalina:       "0c75698174bf89cb29156bb974768f46beb57fc773f810ff568d76cab90273c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "926d363ac4bf963d9db9c81fbf7b420fb2aa84d92aae8f83b74d958c0e9f7b5a"
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
    (share/"examples").install buildpath/"t/maxmind-db/test-data/GeoIP2-City-Test.mmdb"
  end

  test do
    system "#{bin}/mmdblookup", "-f", "#{share}/examples/GeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end
