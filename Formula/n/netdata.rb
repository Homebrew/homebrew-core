class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://www.netdata.cloud/"
  url "https://github.com/netdata/netdata/releases/download/v2.8.0/netdata-v2.8.0.tar.gz"
  sha256 "f52b6ec82020ddb6cdd7b048adadb54136ac987ddfc94c2e46f25682a0f547d1"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "3fef597caa2825aa2b72f717d46c91fece3762bc31ddf23f5e22060f0c979e25"
    sha256 arm64_sequoia: "3b1efc74aeb3a29931ddbf998eed0afa0686c61bec1bb8a5540832df99371610"
    sha256 arm64_sonoma:  "d0e5b7ffce18ce745562cf11006cf505459414f4efe02a3f072fa183c956da62"
    sha256 sonoma:        "e0edb951f70d0b72c847b5671cc44225eed9fc4269c7e45b15164ae07392291f"
    sha256 arm64_linux:   "d198b2af4374765d7ddb952eb57883d3d0377cadfb2ea55745d6be51950dde7d"
    sha256 x86_64_linux:  "06ab99f60be73a4f27b23456d4262991523d09e461fc06415b7712578c37ab7c"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "abseil"
  depends_on "dlib"
  depends_on "json-c"
  depends_on "libuv"
  depends_on "libyaml"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

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
    # Fix to error: no member named 'tcps_sc_zonefail' in 'struct tcpstat'
    # Issue ref: https://github.com/netdata/netdata/issues/20985
    if OS.mac? && MacOS.version >= :tahoe
      inreplace "src/collectors/macos.plugin/macos_sysctl.c",
                'rrddim_set(st, "SyncookiesFailed", tcpstat.tcps_sc_zonefail);',
                ""
    end

    # Install files using Homebrew's directory layout rather than relative to root.
    inreplace "packaging/cmake/Modules/NetdataEBPFLegacy.cmake", "DESTINATION usr/", "DESTINATION "
    inreplace "CMakeLists.txt" do |s|
      s.gsub! %r{(\s"?(?:\$\{NETDATA_RUNTIME_PREFIX\}/)?)usr/}, "\\1"
      s.gsub! %r{(\s"?)(?:\$\{NETDATA_RUNTIME_PREFIX\}/)?etc/}, "\\1#{etc}/"
      s.gsub! %r{(\s"?)(?:\$\{NETDATA_RUNTIME_PREFIX\}/)?var/}, "\\1#{var}/"
      # Fix not to use `fetchContent` for `dlib` library
      # Issue ref: https://github.com/netdata/netdata/issues/20147
      s.gsub! "netdata_bundle_dlib()", "find_package(dlib REQUIRED)"
      s.gsub! "netdata_add_dlib_to_target(netdata)", ""
    end

    args = %w[
      -DBUILD_FOR_PACKAGING=ON
      -DENABLE_PLUGIN_NFACCT=OFF
      -DENABLE_PLUGIN_XENSTAT=OFF
    ]
    # Avoid to use FetchContent for `corrosion`
    args += %w[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
