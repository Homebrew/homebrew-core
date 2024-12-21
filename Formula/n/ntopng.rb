class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  license "GPL-3.0-only"
  revision 2

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
    sha256 arm64_sequoia: "0342fbf3f9f0555a8ae63bca9e58ffcc2978d8022b680872ebf779e73ff74375"
    sha256 arm64_sonoma:  "80574754cd8d1d02c39bad6b33921f9fac544e6b319f56a73cc18ff57d202427"
    sha256 arm64_ventura: "74af363c5bf72edc84af1b411e8379ed7b6ad34b2b6159397a38a7bcc82163d8"
    sha256 sonoma:        "9fdf1fec3559511322cbafd7325ace357281bd76a9a0c51f1d46bbfd8864603d"
    sha256 ventura:       "146234370eef0a7a771049db2b67f81a67548458edc82fb9f8a13babadb6ecfd"
    sha256 x86_64_linux:  "26aa0a5a53f7bcb8bd70f26afa3b2aba2cfcad0d12c9887ded2cfc65038dfb02"
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
  depends_on "pkgconf" => :build
  depends_on "valkey" => :test

  depends_on "hiredis"
  depends_on "json-c"
  depends_on "libmaxminddb"
  depends_on "libsodium"
  depends_on "mariadb-connector-c"
  depends_on "openssl@3"
  depends_on "rrdtool"
  depends_on "sqlite"
  depends_on "zeromq"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "zstd"
  end

  on_linux do
    depends_on "libcap"
  end

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
    valkey_port = free_port
    valkey_bin = Formula["valkey"].bin
    spawn valkey_bin/"valkey-server", "--port", valkey_port.to_s
    sleep 10

    mkdir testpath/"ntopng"
    spawn bin/"ntopng", "-i", test_fixtures("test.pcap"), "-d", testpath/"ntopng", "-r", "localhost:#{valkey_port}"
    sleep 30

    assert_match "list", shell_output("#{valkey_bin}/valkey-cli -p #{valkey_port} TYPE ntopng.trace")
  end
end
