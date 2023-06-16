class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://netdata.cloud/"
  url "https://github.com/netdata/netdata/releases/download/v1.40.0/netdata-v1.40.0.tar.gz"
  sha256 "73b43bada63a793bc27c940af7ef28637d76aba1c014bea01eae8cb77c168175"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "2c0d84de57d2132951d72b129cf47ed9b9597d974e00d4635e68785ee122db90"
    sha256 arm64_monterey: "337b79d895787f0c2fa985b23ff477ff7ee5771cb9ea97bdd70bb2de622a4faf"
    sha256 arm64_big_sur:  "a37969d992ee1fa2633c2384153b61cc216d368b7f9a8de346a981c868d7c0a7"
    sha256 ventura:        "0ec29100f5703f2902a1c890ffbea439e127ba549e2e45b1a7b9944a360dcb0c"
    sha256 monterey:       "0b9b14761e94c9d7cb2362e80a833074da629778391060abaa9ef72ce454e1f9"
    sha256 big_sur:        "f0c5be93bfbc14d7ec871b9a58859f75df323d071109c39781d49c85daf4dc21"
    sha256 x86_64_linux:   "c923d1ce61f3340e4ffac02b49c0d4a7469b906c3d583db73d2424291a3a2142"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "m4" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libuv"
  depends_on "libyaml"
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

  # Remove when https://github.com/netdata/netdata/pull/15195 is merged and
  # included in a release.
  patch do
    url "https://github.com/netdata/netdata/commit/1189341615b642c27faee459b015059778247a8f.patch?full_index=true"
    sha256 "61befe96c549f1428eeb8773864c36bcb825b21854f36a6433112ea9f80dc91d"
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
