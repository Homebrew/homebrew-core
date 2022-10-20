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
    sha256 cellar: :any,                 arm64_monterey: "4dbb3c3109f85e0410c693f6c2765a13f80c057bc5152d4d1a46010816a253a9"
    sha256 cellar: :any,                 arm64_big_sur:  "f0f2ce21927fc5045ee789b91e7c7b7e51153e56f9f3fe47cf0c126cb7767985"
    sha256 cellar: :any,                 monterey:       "c45bd2ec986f0d89121343d2d9ae5b63ae4c08e1b55c816a862237dae1240cb1"
    sha256 cellar: :any,                 big_sur:        "c9b99f5b5f20ca3f12966c45803e49aa7adc13721589b742921837b06fd93a14"
    sha256 cellar: :any,                 catalina:       "7e299f69b73d70f0e59bfdefb5eb99199ed1cf42d2a6592d6b077000b620743d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e4ae0bf5395b1ce3ee5ae26c4397d36ffb414815c20cb34564ef62f8d024199"
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
