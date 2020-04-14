class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"

  stable do
    url "https://github.com/ntop/ntopng/archive/4.0.tar.gz"
    sha256 "caf3aeec5c66eca7ddc3a1d4edc4a109b6c963a22bfcf6843e402a569c8e12a1"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI/archive/3.2.tar.gz"
      sha256 "6808c8c4495343e67863f4d30bb261c1e2daec5628ae0be257ba2a2dea7ec70a"

      # Contains an API change which ntopng 4.0 uses.
      patch do
        url "https://github.com/ntop/nDPI/commit/e4512dbcb9e1db0500290b712257e501d1440d71.patch?full_index=1"
        sha256 "b753532c7c4e68bd20ac432e4ea2159b38609ee7bf6296e96b511222813cc633"
      end
    end
  end

  bottle do
    sha256 "8873e29f3d1884c8ef73a4908a942c66b5f12eb4587843742831fd41cb45d33b" => :catalina
    sha256 "f046d1443aa95c5cd34dc6666560211bea5456b7adeba71559997baa4d809822" => :mojave
    sha256 "b70730c924903d018a4c870c4813d36c6bac0cad0e5f439b6c8aaf4202083cf1" => :high_sierra
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
