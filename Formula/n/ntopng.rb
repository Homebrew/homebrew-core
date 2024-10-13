class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  license "GPL-3.0-only"

  stable do
    url "https://github.com/ntop/ntopng/archive/refs/tags/6.2.tar.gz"
    sha256 "de6ef8d468be3272bce27719ab06d5b7eed6e4a33872528f64c930a81000ccd1"

    depends_on "ndpi"

    # Apply Gentoo patch to force dynamically linking nDPI
    patch do
      url "https://gitweb.gentoo.org/repo/gentoo.git/plain/net-analyzer/ntopng/files/ntopng-5.4-ndpi-linking.patch?id=25646dfc75b15c2bcc9c80ab3aba7a6bab5eec68"
      sha256 "ddbfb32a642e890878bef52c4c8e02232e9f11c132e348c78d47c7865d5649e0"
    end
  end

  bottle do
    sha256 arm64_sequoia: "bd1dc32c1fdffb0e1d9c23400d74c43ebf252e8d755b0a019ec87046e92e697d"
    sha256 arm64_sonoma:  "64288684042c3564bfd3e382d15d661172a2f522e407787d82e6af6f33d309f8"
    sha256 arm64_ventura: "aee5b881035ec900c44dd05416df622b7e9e3d3759dd3b7f9aa715f368492196"
    sha256 sonoma:        "586aa879223843e30fc9136377aa7cd00f3edb16d015d28b14de084e58588d58"
    sha256 ventura:       "7d636609619e74f65df6a7345ad2ea5dad6579cb3d66cb5ce96786abeb62818c"
    sha256 x86_64_linux:  "dcf114d1ce761fb41239ff2c496edcaff98061cdc0ee28b11fc96a0737d024c5"
  end

  head do
    url "https://github.com/ntop/ntopng.git", branch: "dev"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", branch: "dev"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "hiredis"
  depends_on "json-c"
  depends_on "libmaxminddb"
  depends_on "libsodium"
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "redis"
  depends_on "rrdtool"
  depends_on "sqlite"
  depends_on "zeromq"
  depends_on "zlib"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "libpcap"

  on_macos do
    depends_on "zstd"
  end

  on_linux do
    depends_on "libcap"
  end

  fails_with gcc: "5"

  def install
    # Remove bundled libraries
    rm_r Dir["third-party/{json-c,rrdtool}*"]

    args = []
    if build.head?
      resource("nDPI").stage do
        system "./autogen.sh"
        system "make"
        (buildpath/"nDPI").install Dir["*"]
      end
    else
      args << "--with-ndpi-includes=#{Formula["ndpi"].opt_include}/ndpi"
    end

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
    system "make", "install", "MAN_DIR=#{man}"
  end

  test do
    redis_port = free_port
    redis_bin = Formula["redis"].bin
    fork do
      exec redis_bin/"redis-server", "--port", redis_port.to_s
    end
    sleep 10

    mkdir testpath/"ntopng"
    fork do
      exec bin/"ntopng", "-i", test_fixtures("test.pcap"), "-d", testpath/"ntopng", "-r", "localhost:#{redis_port}"
    end
    sleep 30

    assert_match "list", shell_output("#{redis_bin}/redis-cli -p #{redis_port} TYPE ntopng.trace")
  end
end
