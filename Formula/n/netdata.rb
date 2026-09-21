class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://www.netdata.cloud/"
  url "https://github.com/netdata/netdata/releases/download/v2.11.1/netdata-v2.11.1.tar.gz"
  sha256 "388cd947786b4115a2190fd17955d544623d44ac570d6f17e0240c8fb1602c60"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "96ce2166179d75e45636ae928eac743c777901b7c7185e511b596692e09010c6"
    sha256 arm64_tahoe:       "06591f35a33b53ba69d23dda53bb3f12362c4561f18741e60eb5ad829420e0dc"
    sha256 arm64_sequoia:     "6e447f706bd87e89befb0dc84c3ba5283f527fed6661b2f7da0db0f745b5a9d1"
    sha256 arm64_linux:       "99c07639b1fd35b94ea5f2b70f433bda1b4f13f6199e255aa1ec97af6ec2a999"
    sha256 x86_64_linux:      "4e0025fdccab80f13a448d4e2388d77cc8ce82159a1c92364e1126ed840874cb"
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
    # Work around superenv breaking aws-lc-sys `-O0` needed to build CPU Jitter RNG
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"

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
