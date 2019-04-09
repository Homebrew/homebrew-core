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
    sha256 "50b5e9d664fc6b20296a5bdd3715d3b5b3a94e681af848598a0aa14e785758bd" => :mojave
    sha256 "c0c59b7ac0b8529766e6e2a19dee3ceea518cc3f4395d9e699e74f01ee4ff1e9" => :high_sierra
    sha256 "c0727b952e29993aaba518f06a7951602db50cbb41b0757e8cf5f0fe8131d6b6" => :sierra
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
