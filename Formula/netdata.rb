class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://netdata.cloud/"
  url "https://github.com/netdata/netdata/releases/download/v1.38.1/netdata-v1.38.1.tar.gz"
  sha256 "e32a5427f0c00550210dbbf0046c2621313955256edf836db686e2bc270b8d10"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "2a80bbd02b2e74e7e3ca62db0a6354d90639366f578f81358cc331f6149dac88"
    sha256 arm64_monterey: "100707db2257922b0824755abbc44031740893ba6aafede135c1e5862f88e307"
    sha256 arm64_big_sur:  "bc46fa43df8473a15a4b6fd9465a05ef5a49a067b60c9c212973036514f37b61"
    sha256 ventura:        "93673187141fbaebb9e915059f04f4f4714f1949a7327aa8094b3f10f82d9827"
    sha256 monterey:       "f07ab01872255a3e33d739aabc8face039fa8e882925f6cb00fdd6a81014ac81"
    sha256 big_sur:        "51e07b490e9892a6c79a2ebbad6deee5ff3cdbcf226464608bc37c64d3dc78a3"
    sha256 x86_64_linux:   "561ddce963fb1c2c6f3b4b987a0a28b74b9d69449c3afd8ad5b1ba56e822390f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libuv"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  resource "judy" do
    url "https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz"
    sha256 "d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb"
  end

  def install
    # protocolbuffers/protobuf#9947: ABI may depend on NDEBUG
    ENV.append_to_cflags "-DNDEBUG"

    # We build judy as static library, so we don't need to install it
    # into the real prefix
    judyprefix = "#{buildpath}/resources/judy"

    resource("judy").stage do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
          "--disable-shared", "--prefix=#{judyprefix}"

      # Parallel build is broken
      ENV.deparallelize do
        system "make", "-j1", "install"
      end
    end

    ENV["PREFIX"] = prefix
    ENV.append "CFLAGS", "-I#{judyprefix}/include"
    ENV.append "LDFLAGS", "-L#{judyprefix}/lib"

    system "autoreconf", "-ivf"
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --libexecdir=#{libexec}
      --with-math
      --with-zlib
      --enable-dbengine
      --with-user=netdata
    ]
    if OS.mac?
      args << "UUID_LIBS=-lc"
      args << "UUID_CFLAGS=-I/usr/include"
    else
      args << "UUID_LIBS=-luuid"
      args << "UUID_CFLAGS=-I#{Formula["util-linux"].opt_include}"
    end
    system "./configure", *args
    system "make", "clean"
    system "make", "install"

    (etc/"netdata").install "system/netdata.conf"
  end

  def post_install
    (var/"cache/netdata/unittest-dbengine/dbengine").mkpath
    (var/"lib/netdata/registry").mkpath
    (var/"log/netdata").mkpath
    (var/"netdata").mkpath
  end

  service do
    run [opt_sbin/"netdata", "-D"]
    working_dir var
  end

  test do
    system "#{sbin}/netdata", "-W", "set", "registry", "netdata unique id file",
                              "#{testpath}/netdata.unittest.unique.id",
                              "-W", "set", "registry", "netdata management api key file",
                              "#{testpath}/netdata.api.key"
  end
end
