class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://www.netdata.cloud/"
  url "https://github.com/netdata/netdata/releases/download/v2.3.2/netdata-v2.3.2.tar.gz"
  sha256 "ae0ff66a4f9ea44ef4e51fbb331040508f1c12c7f6311bff347fe139870e5dd4"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "a334a47832392466bdefa7e89b29e53e3d972923050984ef19279991cf500fe3"
    sha256 arm64_sonoma:  "89f23e510df8191b58358f39d14abe8c6d5a2c971b1860dc63d7510bfdf289f1"
    sha256 arm64_ventura: "40a5f872a56b690bc3850087ca3794a1f2531b7e145a6a0b2c33fa9b5b4a61d1"
    sha256 sonoma:        "562a755e048d9c12239dcf2b6f84508e16c9d21172274bddb0811ddd4eb365b8"
    sha256 ventura:       "5b3c646dcc2c60938faa0b45e1e4027da6899f590cb34feea7341874e244497d"
    sha256 x86_64_linux:  "c67f1dae0d5667211cf5f3715a5695005955354de81da0df3f8b4857981677d9"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "json-c"
  depends_on "libuv"
  depends_on "libyaml"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "protobuf"
  depends_on "snappy"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "brotli"
    depends_on "elfutils"
    depends_on "freeipmi"
    depends_on "libcap"
    depends_on "libmnl"
    depends_on "systemd"
    depends_on "util-linux"
    depends_on "zstd"
  end

  def install
    # Install files using Homebrew's directory layout rather than relative to root.
    inreplace "packaging/cmake/Modules/NetdataEBPFLegacy.cmake", "DESTINATION usr/", "DESTINATION "
    inreplace "CMakeLists.txt" do |s|
      s.gsub! %r{(\s"?(?:\$\{NETDATA_RUNTIME_PREFIX\}/)?)usr/}, "\\1"
      s.gsub! %r{(\s"?)(?:\$\{NETDATA_RUNTIME_PREFIX\}/)?etc/}, "\\1#{etc}/"
      s.gsub! %r{(\s"?)(?:\$\{NETDATA_RUNTIME_PREFIX\}/)?var/}, "\\1#{var}/"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_FOR_PACKAGING=ON",
                    "-DENABLE_PLUGIN_NFACCT=OFF",
                    "-DENABLE_PLUGIN_XENSTAT=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    directories = prefix.children(false).map(&:to_s)
    %w[usr var etc].each { |dir| refute_includes directories, dir }

    system sbin/"netdata", "-W", "set", "registry", "netdata unique id file",
                           "#{testpath}/netdata.unittest.unique.id",
                           "-W", "set", "registry", "netdata management api key file",
                           "#{testpath}/netdata.api.key"
  end
end
