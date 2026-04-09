class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "https://project-osrm.org/"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  stable do
    url "https://github.com/Project-OSRM/osrm-backend/archive/refs/tags/v6.0.0.tar.gz"
    sha256 "369192672c0041600740c623ce961ef856e618878b7d28ae5e80c9f6c2643031"

    # Backport support for Boost 1.89.0
    patch do
      url "https://github.com/Project-OSRM/osrm-backend/commit/a2e159d0d4f6b3922ee0cb058a800230cf90642e.patch?full_index=1"
      sha256 "296e924268436847b941e287f8c46d0b98e829e723b310d96ff587b51940b653"
    end

    # Backport support for Lua 5.5
    patch do
      url "https://github.com/Project-OSRM/osrm-backend/commit/314c566cd63da80b2a9ced6a71bbb36610113fb9.patch?full_index=1"
      sha256 "5e259e4ff3ab48cff4ce1a947fde14de8bf5f0d99d79ac407804af4637e871ad"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e74008d49cd71d3efd5b7006a2809848ca73f15c923be180ef4f6de6edc79f59"
    sha256 cellar: :any,                 arm64_sequoia: "ea5588b2c7e83b37fa376b43b2ce3f9b62b614ebdb55bc826dce885cad7c7797"
    sha256 cellar: :any,                 arm64_sonoma:  "0a82e6177cf9cd25b69d0e1eb9e5ba8c1468af67e7595e91bc2d7a6d5e7f13a1"
    sha256 cellar: :any,                 sonoma:        "91283bc8dd2b37363db095c04c025354b0f7869a2e316eb8f7e49ea5b56145be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b1cd90a2989c42e0f000e10480d15ff2d4dd86ac1ecf790722dd63064891b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef5a80bc12c171d942fc5a74153b0d7a0a4c47f2b1eb5ba33374ab2bc2f1bc94"
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
