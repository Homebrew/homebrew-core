class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "https://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/refs/tags/v26.7.3.tar.gz"
  sha256 "b4ab1375f569eefd2aa8015c1e3890d10633234bfb5a9167faccfc91833d05e9"
  license "BSD-2-Clause"
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d9e04f014185a0236982eb511413da83e91ebd5a65165e7f14bb6d4f10eb38bc"
    sha256 cellar: :any, arm64_sequoia: "64935f16148789bc607f480126af2b0e550ae85aacbe53ff6caf1d4fafb31e78"
    sha256 cellar: :any, arm64_sonoma:  "56ef4ce95ca0657e8dff4d76170213af5e395629fc92ef20a7c9489e42d81b68"
    sha256 cellar: :any, sonoma:        "f1b87ccb8ad956eb14a3541ef378eba4abe04756b10d9bc5e397f1a7ef7e4188"
    sha256 cellar: :any, arm64_linux:   "b49d6b528d08590417027d21497b1891c3ca95e484c3e331059c4d22ebbbc691"
    sha256 cellar: :any, x86_64_linux:  "533290ca2cac115a17df90227958ee51d7bc6dcf627b026bc806cd4260785216"
  end

  depends_on "cmake" => :build
  depends_on "flatbuffers" => :build
  depends_on "fmt" => :build
  depends_on "libosmium" => :build
  depends_on "pkgconf" => :build
  depends_on "protozero" => :build
  depends_on "rapidjson" => :build
  depends_on "sol2" => :build
  depends_on "vtzero" => :build

  depends_on "boost"
  depends_on "libarchive"
  depends_on "lua"
  depends_on "tbb"

  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1600
    cause "Requires C+++20 support for `std::atomic_ref`"
  end

  fails_with :gcc do
    version "11"
    cause <<~CAUSE
      /usr/include/c++/11/type_traits:987:52: error: static assertion failed: template argument must be a complete class or an unbounded array
        static_assert(std::__is_complete_or_unbounded(__type_identity<_Tp>{}),
    CAUSE
  end

  def install
    lua = Formula["lua"]
    luaversion = lua.version.major_minor

    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_CCACHE:BOOL=OFF",
                    "-DLUA_INCLUDE_DIR=#{lua.opt_include}/lua#{luaversion}",
                    "-DLUA_LIBRARY=#{lua.opt_lib/shared_library("liblua", luaversion.to_s)}",
                    "-DENABLE_GOLD_LINKER=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "profiles"
  end

  test do
    node1 = 'visible="true" version="1" changeset="676636" timestamp="2008-09-21T21:37:45Z"'
    node2 = 'visible="true" version="1" changeset="323878" timestamp="2008-05-03T13:39:23Z"'
    node3 = 'visible="true" version="1" changeset="323878" timestamp="2008-05-03T13:39:23Z"'

    (testpath/"test.osm").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <osm version="0.6">
       <bounds minlat="54.0889580" minlon="12.2487570" maxlat="54.0913900" maxlon="12.2524800"/>
       <node id="1" lat="54.0901746" lon="12.2482632" user="a" uid="46882" #{node1}/>
       <node id="2" lat="54.0906309" lon="12.2441924" user="a" uid="36744" #{node2}/>
       <node id="3" lat="52.0906309" lon="12.2441924" user="a" uid="36744" #{node3}/>
       <way id="10" user="a" uid="55988" visible="true" version="5" changeset="4142606" timestamp="2010-03-16T11:47:08Z">
        <nd ref="1"/>
        <nd ref="2"/>
        <tag k="highway" v="unclassified"/>
       </way>
      </osm>
    XML

    (testpath/"tiny-profile.lua").write <<~LUA
      function way_function (way, result)
        result.forward_mode = mode.driving
        result.forward_speed = 1
      end
    LUA

    safe_system bin/"osrm-extract", "test.osm", "--profile", "tiny-profile.lua"
    safe_system bin/"osrm-contract", "test.osrm"
    assert_path_exists testpath/"test.osrm.names", "osrm-extract generated no output!"
  end
end
