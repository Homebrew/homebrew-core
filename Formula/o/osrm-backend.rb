class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "https://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "369192672c0041600740c623ce961ef856e618878b7d28ae5e80c9f6c2643031"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a523c41c98db822786dc645c024d5874f0f3e79e88a98772d57754bfafa386dd"
    sha256 cellar: :any,                 arm64_sequoia: "429bafcaf7b635be6b0054cda48bb75a2284bff9dd1a31254bfa36edd39213b6"
    sha256 cellar: :any,                 arm64_sonoma:  "8b35c97fd01b53541fed0807aaca33249fc3cae5cdeda156c2b8cc4fcb6799b6"
    sha256 cellar: :any,                 arm64_ventura: "279149ff05cfe64f42403a6ce4e82dff3381a5ecaf79895eaa3b27f9a6d76c93"
    sha256 cellar: :any,                 sonoma:        "6a683f6cd29d8a81e1e410c2df5d4718105b69143d4cddceab70cccb95eb9429"
    sha256 cellar: :any,                 ventura:       "718788e54ac80005c8da8bd66e918c93c84ef32c92c991043ccf0f8a6f0ec813"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7be21e22dbf762808c40691c50ca45a918298c241cb6195e8f5702cec2d58b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd60664efed3fe7d87f93b5ebaf6e925c98121cf429ce89c8eb92429f646d020"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "libstxxl"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"
  depends_on "tbb"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc@12" if DevelopmentTools.gcc_version("gcc") < 12

    fails_with :gcc do
      version "11"
      cause <<~CAUSE
        /usr/include/c++/11/type_traits:987:52: error: static assertion failed: template argument must be a complete class or an unbounded array
          static_assert(std::__is_complete_or_unbounded(__type_identity<_Tp>{}),
      CAUSE
    end
  end

  conflicts_with "flatbuffers", because: "both install flatbuffers headers"

  # Fix build with Boost 1.89.0, pr ref: https://github.com/Project-OSRM/osrm-backend/pull/7220
  patch do
    url "https://github.com/Project-OSRM/osrm-backend/commit/5cea5057eb766a19fbecb68e7392e42589ce1d46.patch?full_index=1"
    sha256 "51f4f089e6e29264e905661e8cf78e4707af6e004de4a2fba22c914d1c399ff5"
  end

  def install
    # Work around build failure: duplicate symbol 'boost::phoenix::placeholders::uarg9'
    # Issue ref: https://github.com/boostorg/phoenix/issues/111
    ENV.append_to_cflags "-DBOOST_PHOENIX_STL_TUPLE_H_"
    # Work around build failure on Linux:
    # /tmp/osrm-backend-20221105-7617-1itecwd/osrm-backend-5.27.1/src/osrm/osrm.cpp:83:1:
    # /usr/include/c++/11/ext/new_allocator.h:145:26: error: 'void operator delete(void*, std::size_t)'
    # called on unallocated object 'result' [-Werror=free-nonheap-object]
    ENV.append_to_cflags "-Wno-free-nonheap-object" if OS.linux?

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
