class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  license "GPL-3.0-only"
  revision 1

  stable do
    url "https://github.com/ntop/ntopng/archive/4.2.tar.gz"
    sha256 "c7ce8d0c7b4251aef276038ec3324530312fe232d38d7ad99de21575dc888e8b"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI/archive/3.4.tar.gz"
      sha256 "dc9b291c7fde94edb45fb0f222e0d93c93f8d6d37f4efba20ebd9c655bfcedf9"
    end
  end

  bottle do
    sha256 "c33e2a4f6810ac49db5dc300c8d7d4c39624dfa2f7a39c72ea57944a7738cba0" => :big_sur
    sha256 "f0e5aaae68dd3871080bd883980fa3d057d20265fe0226d1e1b6252950743d57" => :catalina
    sha256 "fcfb0e2352a5baaa20c2242fdf6ce8b57b9cca29e4d75506a2bd3dcff0eaf2fa" => :mojave
    sha256 "b193e487d16c3ce483e1cbcd3e45731dcc75c356ffc262975b1bed3c2a5cd717" => :high_sierra
  end

  head do
    url "https://github.com/ntop/ntopng.git", branch: "dev"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", branch: "dev"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnutls" => :build
  depends_on "json-glib" => :build
  depends_on "libtool" => :build
  depends_on "lua" => :build
  depends_on "pkg-config" => :build
  depends_on "zeromq" => :build
  depends_on "geoip"
  depends_on "json-c"
  depends_on "libmaxminddb"
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
    redis_port = free_port
    redis_bin = Formula["redis"].bin
    fork do
      exec redis_bin/"redis-server", "--port", redis_port.to_s
    end
    sleep 3

    mkdir testpath/"ntopng"
    fork do
      exec bin/"ntopng", "-i", test_fixtures("test.pcap"), "-d", testpath/"ntopng", "-r", "localhost:#{redis_port}"
    end
    sleep 15

    assert_match "list", shell_output("#{redis_bin}/redis-cli -p #{redis_port} TYPE ntopng.trace")
  end
end
