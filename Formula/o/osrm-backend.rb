class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "https://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "369192672c0041600740c623ce961ef856e618878b7d28ae5e80c9f6c2643031"
  license "BSD-2-Clause"
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d99d43985b7eb9874b9a854559a8dd7ba095653a0bc7991f540a9f691098f381"
    sha256 cellar: :any,                 arm64_sonoma:  "1238dc214ee091861d48367a2c78b5458ccdfdd6737404fd8184f4dd815e6d34"
    sha256 cellar: :any,                 arm64_ventura: "af0a8f5ceb7d82b9aece2b378d98d9d2aefbd830a9cfbaba79d5433160540528"
    sha256 cellar: :any,                 sonoma:        "fb84337d531fe6c48eee4a7dd0abf33cc4ad0af6742abf9466880847e1470ba1"
    sha256 cellar: :any,                 ventura:       "2eeecffa84cf777cb0e381b6e6e61ce41fc32ca7aa7b5a8c0244410d585c7c8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aa04dc44e906b36396551a0acc0482eaad60ebb811243bafa85f2c39d2903c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc54945839a76c5d681129b99814b936674ef7caf365a7d9d45919d79710f160"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "lua"
  depends_on "tbb"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"

    fails_with :gcc do
      version "11"
      cause <<~CAUSE
        /usr/include/c++/11/type_traits:987:52: error: static assertion failed: template argument must be a complete class or an unbounded array
          static_assert(std::__is_complete_or_unbounded(__type_identity<_Tp>{}),
      CAUSE
    end
  end

  conflicts_with "flatbuffers", because: "both install flatbuffers headers"

  def install
    lua = Formula["lua"]
    luaversion = lua.version.major_minor

    # TODO: Add `-DBUILD_SHARED_LIBS=ON` on macOS (but not Linux unless GCC 12+ is default)
    # after upstream issue https://github.com/Project-OSRM/osrm-backend/issues/6954 is fixed
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_CCACHE:BOOL=OFF",
                    "-DLUA_INCLUDE_DIR=#{lua.opt_include}/lua#{luaversion}",
                    "-DLUA_LIBRARY=#{lua.opt_lib/shared_library("liblua", luaversion.to_s)}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "profiles"

    # Remove C++ libraries from Linux bottle. Can consider restoring once GCC 12 is default
    rm_r([include, lib]) if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
  end

  def caveats
    on_linux do
      <<~CAVEATS
        The bottle does not include C++ libraries as core formulae are
        not allowed to have a Linux-only GCC dependency for libraries.
      CAVEATS
    end
  end

  test do
    refute_path_exists lib if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

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
