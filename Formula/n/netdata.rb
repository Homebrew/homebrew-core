class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://www.netdata.cloud/"
  url "https://github.com/netdata/netdata/releases/download/v2.2.6/netdata-v2.2.6.tar.gz"
  sha256 "bd98c146aa6d0c25f80cb50b1447b8aca8a17f0995b28a11a23e843b8f210f42"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "86659b5011bb7f7d2caacdbffe8bfb52e570026eefcc28db297c58e13cc55105"
    sha256 arm64_sonoma:  "7f49dca20ba3a479be97800eb84790be64e3fb8a2d1d658ed6160d266068b081"
    sha256 arm64_ventura: "f9d215d7780084e9d4d61a76c810ec7e1c45c9dbaf6c0613cb626a89fcc97026"
    sha256 sonoma:        "e7985f32bb0bcc982a520d01b95d65a8e7e9ac18e81e427dec281bfa7a7413ef"
    sha256 ventura:       "a7802a15c80aafd9504c875db123906c5d70887578597a51ab9bb26380bc13fc"
    sha256 x86_64_linux:  "1ea6bc52591b731ffecebc4e3cc134f51b6aeb9c48645bc70e0c0a7dfe9a7f49"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "curl"
  depends_on "json-c"
  depends_on "libuv"
  depends_on "libyaml"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "protobuf"
  depends_on "protobuf-c"

  uses_from_macos "zlib"

  on_linux do
    depends_on "bison"
    depends_on "elfutils"
    depends_on "flex"
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
      system "./configure", "--disable-shared", *std_configure_args(prefix: judyprefix)

      # Parallel build is broken
      ENV.deparallelize do
        system "make", "install"
      end
    end

    inreplace "CMakeLists.txt" do |s|
      s.gsub!(%r{(?<!/)usr/}, "#{prefix}/")
      s.gsub!("/usr/", "/")
    end

    ENV.append "CFLAGS", "-I#{judyprefix}/include"
    ENV.append "LDFLAGS", "-L#{judyprefix}/lib"

    args = [
      "-DBUILD_FOR_PACKAGING=1",
      "-DNETDATA_RUNTIME_PREFIX=#{prefix}",
    ]

    if OS.mac?
      args << "UUID_LIBS=-lc"
      args << "UUID_CFLAGS=-I/usr/include"
    else
      args << "UUID_LIBS=-luuid"
      args << "UUID_CFLAGS=-I#{Formula["util-linux"].opt_include}"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (prefix/"etc/netdata").install "#{buildpath}/system/netdata.conf"
  end

  def post_install
    (var/"cache/netdata/unittest-dbengine/dbengine").mkpath
    (var/"lib/netdata/registry").mkpath
    (var/"lib/netdata/lock").mkpath
    (var/"log/netdata").mkpath
    (var/"netdata").mkpath
  end

  service do
    run [opt_sbin/"netdata", "-D"]
    working_dir var
  end

  test do
    system sbin/"netdata", "-W", "set", "registry", "netdata unique id file",
                           "#{testpath}/netdata.unittest.unique.id",
                           "-W", "set", "registry", "netdata management api key file",
                           "#{testpath}/netdata.api.key"
  end
end
