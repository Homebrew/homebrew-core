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
    sha256 "d9070a2ff65e1ec34243718f4b34ee9553c19ce71a79f5d8bd570c4bbce41bef" => :mojave
    sha256 "4ea92032db7726e6852c63bd494fd9037cf726cd3628ad83c0dd13f0b4d271bc" => :high_sierra
    sha256 "c25c7c8f23a1d1f01c0bd1a170ccb0c295272716da1bcf9885a59292ca654962" => :sierra
    sha256 "5da4764c214a070d75364d2f240c100271d886b0f2b31847a68ea369a4fddc8f" => :el_capitan
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
