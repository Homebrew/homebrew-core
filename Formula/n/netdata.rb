class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://www.netdata.cloud/"
  url "https://github.com/netdata/netdata/releases/download/v2.6.1/netdata-v2.6.1.tar.gz"
  sha256 "663692f5671fa752e0240e519eca3683a777a7bd6ced880c8b573856b773b33b"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "351a409645c9103d5d78427b3c7771a5643e226a9b9e2501c157ea23f6b7602b"
    sha256 arm64_sonoma:  "d3c8b0bcd9b708d5b7c40e0833783c41a1ee20c61d96b65178a3cd46643ce665"
    sha256 arm64_ventura: "a4d774188bac79387b48b8768cdfa212456381e1dc41a95da06594362f7d2282"
    sha256 sonoma:        "1847f6910872cf2bb49bd077e9d037ba0a60b4ef46d65c7ff445106d21f5e695"
    sha256 ventura:       "674058a3c4517be961ece61bdab7f23c36e4f40fc8b5b40ff882253f921f7348"
    sha256 x86_64_linux:  "ff878f4b2aae7b16ec8cecfefb027f8274a9dacf520260adf7f7d96b48d27c74"
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
