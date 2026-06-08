class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "https://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/refs/tags/v26.6.5.tar.gz"
  sha256 "fc007a189704dda8527158ad6aab38ccfd2a9533042c3c80f41f7a0659e924fb"
  license "BSD-2-Clause"
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c54bd191da7ff283d722d9137621d7df5960069a82b12be9d1f5ce869ff065b8"
    sha256 cellar: :any, arm64_sequoia: "f67fecec3ba4f7bd4db0dc4413b8228aa41faf3a48230ea51c8f312c509eb73d"
    sha256 cellar: :any, arm64_sonoma:  "de82c8f0c91e47ab5318b0871e8f17fd483fe88339d7a20d14e808e6d4a01c56"
    sha256 cellar: :any, sonoma:        "2bbf0127bf286e0429b1064a405c60546e5d2bf30f85d334101bde0c22ab61e7"
    sha256 cellar: :any, arm64_linux:   "eb9c3b0a822bf9830aef21afc94a015e9120f375a21e7323256a070743f9b2a2"
    sha256 cellar: :any, x86_64_linux:  "ff56b2480852bbdaef80f6249e1d8af33322335ec3d3e2de100fb32e1ec7264c"
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
