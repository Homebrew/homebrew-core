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
    sha256 cellar: :any,                 arm64_tahoe:   "bafbf8e9eeeb7fd967b9af6248ea3da9c9b13624c67eb8ff2cbdf4972c57d501"
    sha256 cellar: :any,                 arm64_sequoia: "786d42ac7d079d97505d526a642082294c8a2efc846de8315306373c85091606"
    sha256 cellar: :any,                 arm64_sonoma:  "686afbf247935ef86b3ff3414e22a33a57bd1d9f28d4ba0e1cc6f45ec3d38f89"
    sha256 cellar: :any,                 sonoma:        "05bc24eecd136bab1f072af2de909bc43b4a6e620459ec064721aaca61075142"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "189865032379b3123c27e762ea15b06aa9011fb44590f50bf623608a11e1ffc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72788187b68a1d6066bf407a81260c24d10f46b501844d7844fab9fd0a880d4f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "lua"
  depends_on "tbb"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

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
