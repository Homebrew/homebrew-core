class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "https://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "369192672c0041600740c623ce961ef856e618878b7d28ae5e80c9f6c2643031"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "edfb58fb08cdb110fbe738784b979f256da6e7f34af49fc6d667669fc41d3f4a"
    sha256 cellar: :any,                 arm64_sequoia: "99d0f1dd0fe21b15366c661cdbb8716fa5753a0b2b1e5473c485e80a372518a2"
    sha256 cellar: :any,                 arm64_sonoma:  "7002b90376549c85c6b5d7beca1d1afa39cbe9cbdcb0f904cb825e611d0c1ca1"
    sha256 cellar: :any,                 sonoma:        "a7df306403150d35d66ce2a2fa96a3ea12cbd9021468cbdefe6b30560398af46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e68d7ae70beae95b5aeef1840affbac9d0774000bb6014791e4262b0eedf208e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fed92de2c0585e16bb7a1c2d2cc8b9538d935b93814aa4f800732ca26a60062"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "lua"
  depends_on "tbb"

  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "flatbuffers", because: "both install flatbuffers headers"

  fails_with :gcc do
    version "11"
    cause <<~CAUSE
      /usr/include/c++/11/type_traits:987:52: error: static assertion failed: template argument must be a complete class or an unbounded array
        static_assert(std::__is_complete_or_unbounded(__type_identity<_Tp>{}),
    CAUSE
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/Project-OSRM/osrm-backend/pull/7220
  patch do
    url "https://github.com/Project-OSRM/osrm-backend/commit/5cea5057eb766a19fbecb68e7392e42589ce1d46.patch?full_index=1"
    sha256 "51f4f089e6e29264e905661e8cf78e4707af6e004de4a2fba22c914d1c399ff5"
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
