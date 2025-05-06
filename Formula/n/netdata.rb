class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://www.netdata.cloud/"
  url "https://github.com/netdata/netdata/releases/download/v2.5.0/netdata-v2.5.0.tar.gz"
  sha256 "eb98dfe1aad6a97b48976c1888ec07adb5a26eb316e2e12d0d0efb928a801340"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "3dd852ad855928a1efefa6acd7dba57d5f82baec20cdaafadf6382ffed8bd3ce"
    sha256 arm64_sonoma:  "d9fcfb438c4f9b7d2c77bac12ff9c9d7630b863ae9c75968235b897e9ecb7e92"
    sha256 arm64_ventura: "8e602f35b2f98b93c4e1fd74c398ea35b535dd38834ab259bf040289026c79ab"
    sha256 sonoma:        "317f89b6e54789012d0db26b6b19fedcf1f3c01033bf809080920fd8202787c6"
    sha256 ventura:       "9e36fa4488255ef6518f8bd873764f88d72697ce9b50e5f3a8b638e31839e4c3"
    sha256 x86_64_linux:  "afbe44f18e7884efd52ffc60cae0255814b55e9e6d0dd0dd4e6726813b3d8a29"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "pkgconf" => :build
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
