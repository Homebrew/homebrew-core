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
    sha256 arm64_sequoia: "9f6d0f239b8dc0835e0698849377f502301bc4299936fb3d0aba624e11885604"
    sha256 arm64_sonoma:  "be65c430079ebbe79ab62ce1ffce5aa7d084fc0b33bc7153b0e1b57bb240c3ad"
    sha256 arm64_ventura: "a80a9b44e9aaa5852b96d308be805bc44099e83487d92f2cd28f6a88442c73f5"
    sha256 sonoma:        "df1b923da4e9371ba304e9f72713c6672cc124bc803bde6402e93f9e654fdde0"
    sha256 ventura:       "4da8a2ccd7d3c0092e1a95c73b36b8a01d8b1ed2dab9f64e004a57b37274c565"
    sha256 arm64_linux:   "9328b2d8059fc248392e57bf053ac1d2c0ced06c1cb997ea93e2cf269936800b"
    sha256 x86_64_linux:  "81e384a601f5d00d27a9ec914e9bd4b25266999afa15e4e11a9ad3109609a4b9"
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
