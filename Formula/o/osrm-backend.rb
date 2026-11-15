class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "https://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/refs/tags/v26.11.0.tar.gz"
  sha256 "d08387e3cb2faad4acdcfaca6ebdacc7faab16e73662c2a6a9558b7450908372"
  license "BSD-2-Clause"
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "72996859df84d1d93356de2792bf1c773a3c9d7c5da8a339606edc97440975dd"
    sha256 cellar: :any, arm64_tahoe:       "40105351ada732b8ee2441b5be853d66e33b9b183185e4b3204aa389db644099"
    sha256 cellar: :any, arm64_sequoia:     "bc3a080fe2faa416ab6ef2fa87dc751889d2b30f2b82cd2036f197da3cc0976d"
    sha256 cellar: :any, arm64_linux:       "2d844ba89138280c591d6874db45fbf1afc29105473be9fbfcc81c4e00140769"
    sha256 cellar: :any, x86_64_linux:      "fab80cc25b98fb7e20188d3d9eb59b1f1afb23e62bd0f30b4c68a14f22def4fd"
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

  resource "gauche" do
    url "https://github.com/Project-OSRM/gauche-rs/archive/b1c3af3029975ddbe573bad874c4520db77321d0.tar.gz"
    sha256 "8b0e810d1b54285bb78a81050e0954ff70f4d6f8a67f84f4c9771c713f80ac08"
  end

  def install
    resource("gauche").stage do
      system "cmake", "-S", "cpp", "-B", "build", *std_cmake_args(install_prefix: libexec/"gauche"),
                      "-DBUILD_SHARED_LIBS=OFF", "-DGAUCHE_BUILD_EXAMPLES=OFF"
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
      (libexec/"gauche").install "LICENSE"
    end

    lua = Formula["lua"]
    luaversion = lua.version.major_minor

    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_CCACHE:BOOL=OFF",
                    "-DLUA_INCLUDE_DIR=#{lua.opt_include}/lua#{luaversion}",
                    "-DLUA_LIBRARY=#{lua.opt_lib/shared_library("liblua", luaversion.to_s)}",
                    "-DENABLE_GOLD_LINKER=OFF",
                    "-Dgauche_DIR=#{libexec}/gauche/lib/cmake/gauche",
                    "-DCMAKE_CXX_FLAGS=-I#{libexec}/gauche/include",
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
