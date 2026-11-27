class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://www.netdata.cloud/"
  url "https://github.com/netdata/netdata/releases/download/v2.13.0/netdata-v2.13.0.tar.gz"
  sha256 "510db7699c76c44f3d4bcebec854d5a29ecdc3cf3bfadfe78e27ee7ea87f8491"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "8ae82e7d7a49352080ca443f3a4cf12b280742f8072d4cf3cc8f9c7bbf90fc82"
    sha256 arm64_golden_gate: "70482ff12f3fdc265d02179a29ac8cd3ffb38acb2ab1201d75e4039f35d55bc2"
    sha256 arm64_tahoe:       "c6d0a89a0ad250ce86a8b9c2899ac4614cde060ec478538a4260fe794b543b2e"
    sha256 arm64_sequoia:     "9d45fb9c9358ce9687b4421d5e43543e91d4b56ab9a53258172b8d5d2a343814"
    sha256 arm64_linux:       "9a3c26546f92a620cf0b079c8ed327d7ebea4df64e00c6539c722a50f612e2e6"
    sha256 x86_64_linux:      "d7a26318e1c2ba787d455606a87c5229951d8e883c4a21e549821f76a2ff981b"
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
  depends_on "openssl@4"
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
    inreplace "CMakeLists.txt", "set(BINDIR usr/sbin)", "set(BINDIR sbin)"
    inreplace %w[InstallLayout Options SystemFiles].map { |m| "packaging/cmake/Modules/Netdata#{m}.cmake" },
              '"usr/', '"'
    inreplace "packaging/cmake/Modules/NetdataInstallLayout.cmake" do |s|
      s.gsub! '"etc/', "\"#{etc}/"
      s.gsub! '"var/', "\"#{var}/"
      s.gsub! %r{\$\{NETDATA_RUNTIME_PREFIX\}/(\$\{(?:CACHE|CONFIG|LOG|VARLIB)_DEST\})}, "\\1"
    end

    # Fix not to use `fetchContent` for `dlib` library
    # Issue ref: https://github.com/netdata/netdata/issues/20147
    inreplace "CMakeLists.txt", "netdata_bundle_dlib()", "find_package(dlib REQUIRED)"
    inreplace "packaging/cmake/Modules/NetdataDaemon.cmake", "netdata_add_dlib_to_target(netdata)", ""

    args = %w[
      -DNETDATA_PACKAGE_KIND=deb
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
