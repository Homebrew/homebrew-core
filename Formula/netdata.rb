class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://netdata.cloud/"
  url "https://github.com/netdata/netdata/releases/download/v1.36.1/netdata-v1.36.1.tar.gz"
  sha256 "f4a1233112b55e07e2862ffda0416255f0aa4c8e2b16929b76fa7ad6b69fd931"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "12c7e2d3ad0089dca85be9578409dfd744558c221ea7e3650633a07a61aa5a0e"
    sha256 arm64_monterey: "d512dabe93ee951a8952636e2e006da4570ddc6c8bd496613f23f4779e43d31e"
    sha256 arm64_big_sur:  "b0eb5533886dfc014f02b8015fdbeca1b3b8143e4911129870ae08fba11d020c"
    sha256 ventura:        "409139e6d22caa5d43fe2c86085ffb1c6219ed23a8f81a2b0e41ea63f34da0fa"
    sha256 monterey:       "4eb1331def7402540fbbbc9b7a5591f7ca13f2e1211afecf02cdaabbf0d2b646"
    sha256 big_sur:        "f901b0389f560f986a9466e261782312bc90f91649e5f31804a6729b4272b202"
    sha256 catalina:       "408ef315509af5d834b522de314d6f7f1075a569acf0ea2155a9caeeb7d8d5a6"
    sha256 x86_64_linux:   "6dde898bd4c5e0b43ef50ba8968f97adadc4bb7fb2092da28934b050655e2b9c"
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
    # https://github.com/protocolbuffers/protobuf/issues/9947
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
