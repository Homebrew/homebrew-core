class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"

  stable do
    url "https://github.com/ntop/ntopng/archive/3.8.tar.gz"
    sha256 "683d28aece3bf3f17c3d53d7a76fbd2a24719767477f5dce55268683fd87f821"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI/archive/2.6.tar.gz"
      sha256 "efdfb68940385b18079920330528978765dc2a90c8163d10f63301bddadbf91e"
    end
  end

  bottle do
    rebuild 1
    sha256 "7df3adf0ac7d3f5ea92fb4611c92fae5401fe9e29f1186f828deb47ef01d0f16" => :catalina
    sha256 "8eda47ae0274ebe3557e43b3f77dd03e5f2d817fb112c6bbe353e812b1545b8e" => :mojave
    sha256 "4a8f83d19c03888ef27a8c9d47f8612adc1ccfa02c2381048dd738e9146b0e73" => :high_sierra
    sha256 "f90a831a2a31441ab63d252c75ec4720ba32420d1b03963f3e013e7f1e79e13a" => :sierra
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
