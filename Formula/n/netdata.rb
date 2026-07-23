class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://www.netdata.cloud/"
  url "https://github.com/netdata/netdata/releases/download/v2.10.4/netdata-v2.10.4.tar.gz"
  sha256 "d1ae949863925d626b1d42a53000bcca2c239718e0b0ddc6a3f3f5029b21cdfe"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "fe74985f6a9084f7953880b0023ee8699cd7afebc78d069fc0013104b897cf40"
    sha256 arm64_sequoia: "32b6db246b17593a98b28732658a530d5b408c7eaf4967defe3c891191a48d50"
    sha256 arm64_sonoma:  "59af3fc22617b8ee8d79ae8e540ed55c7544b052f9481e26a40e6f8523850323"
    sha256 sonoma:        "36f581ea0adc0d8541f509ee4268dd644ef8c6a8f6ac619dc81d949acf704624"
    sha256 arm64_linux:   "37d73bbc9073b886ca32a6c119ddcb5940c62e807b80dab1d4995a62b196339e"
    sha256 x86_64_linux:  "036ebf59b0776420a037ffb49b022a16fad64dabdb0c9ff1cb7bf309d2ef3b2c"
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
    depends_on "zlib-ng-compat"
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
