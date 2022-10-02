class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  license "BSD-2-Clause"
  revision 3

  stable do
    url "https://github.com/Project-OSRM/osrm-backend/archive/v5.26.0.tar.gz"
    sha256 "45e986db540324bd0fc881b746e96477b054186698e8d14610ff7c095e906dcd"
    depends_on "tbb@2020"
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "30e473b97a8b623eec3d602e45e7e21c4e44b761ca4e2c4ef724c87614498b75"
    sha256 cellar: :any,                 arm64_big_sur:  "4d13b51a5e03c17cb60de48d738ab1ec08946114baa298a24482f76f784ec226"
    sha256 cellar: :any,                 monterey:       "b98e83beb4c841c9289b6efb8d1b058ea97c5b6411c6132903001d0fe84ba834"
    sha256 cellar: :any,                 big_sur:        "f0943390ad90826d2def7a9c7fc27f214a20cc9dc6886d47ec309b852916c4d8"
    sha256 cellar: :any,                 catalina:       "74825bed2c07fd6e5a5862c4dd66e9eff13818ae83ab3d8f62034db38bd9fb20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e78299d0601d9aefce6ba8d0597e256ae57dfc7890b88a9f03701e10155d08a"
  end

  head do
    url "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"
    depends_on "tbb"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libstxxl"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"

  conflicts_with "flatbuffers", because: "both install flatbuffers headers"

  def install
    lua = Formula["lua"]
    luaversion = lua.version.major_minor
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_CCACHE:BOOL=OFF",
                    "-DLUA_INCLUDE_DIR=#{lua.opt_include}/lua#{luaversion}",
                    "-DLUA_LIBRARY=#{lua.opt_lib/shared_library("liblua", luaversion)}",
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

    (testpath/"test.osm").write <<~EOS
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
    EOS

    (testpath/"tiny-profile.lua").write <<~EOS
      function way_function (way, result)
        result.forward_mode = mode.driving
        result.forward_speed = 1
      end
    EOS
    safe_system "#{bin}/osrm-extract", "test.osm", "--profile", "tiny-profile.lua"
    safe_system "#{bin}/osrm-contract", "test.osrm"
    assert_predicate testpath/"test.osrm", :exist?, "osrm-extract generated no output!"
  end
end
