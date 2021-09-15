class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  license "GPL-3.0-only"

  stable do
    url "https://github.com/ntop/ntopng/archive/5.0.tar.gz"
    sha256 "e540eb37c3b803e93a0648a6b7d838823477224f834540106b3339ec6eab2947"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git",
        revision: "46ebd7128fd38f3eac5289ba281f3f25bad1d899"
    end
  end

  bottle do
    sha256 big_sur:      "6c03ede014ebd615cb2716898b11d48af7973eef1c9c2f4a5c24d11fda776be8"
    sha256 catalina:     "115f0cb4514aacda5ba0fc003afc96659249a8ce26287ea340810cc48791e1da"
    sha256 mojave:       "199498493df28a4c3d0d2f6aa211f02954997db319a4c4f58ad00c3ccb95fbc8"
    sha256 x86_64_linux: "e802bb58c1e615986813d879b5c045900a8f88854b7d454aed13a0b4df89d632"
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
  depends_on "geoip"
  depends_on "json-c"
  depends_on "libmaxminddb"
  depends_on "mysql-client"
  depends_on "redis"
  depends_on "rrdtool"
  depends_on "zeromq"

  uses_from_macos "curl"
  uses_from_macos "libpcap"
  uses_from_macos "sqlite"

  def install
    resource("nDPI").stage do
      system "./autogen.sh"
      system "make"
      (buildpath/"nDPI").install Dir["*"]
    end
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install", "MAN_DIR=#{man}"
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
