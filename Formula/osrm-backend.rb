class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/v5.26.0.tar.gz"
  sha256 "45e986db540324bd0fc881b746e96477b054186698e8d14610ff7c095e906dcd"
  license "BSD-2-Clause"
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "f858c74b178e7d35752ca0ae3a61772421ea04ccff1041d27ee05433184b12d2"
    sha256 cellar: :any, arm64_big_sur:  "a5247545b04b669711587d73ce192211669e4af288c5bce14923413936d285bf"
    sha256 cellar: :any, monterey:       "c93ccda074ddfe27d18e17ef25aae4d5956dbab10eb45f4e1ac6ffb4ab9b3d03"
    sha256 cellar: :any, big_sur:        "8aa632bde01a2f6566bbb006876a8d50af00bea45956e17ae0ddc87dd2278294"
    sha256 cellar: :any, catalina:       "7caf6151936c3279afdf5c4e4b3bd5a81dbad1c33266a8fe80d3dbbeae5f7f79"
    sha256 cellar: :any, mojave:         "e0b2e44267afd48717484ffc86fdee8096ec27020dcd2be0e2735b3cb2aef468"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libstxxl"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"
  depends_on "tbb@2020"

  def install
    lua = Formula["lua"]
    luaversion = lua.version.major_minor
    mkdir "build" do
      system "cmake", "..", "-DENABLE_CCACHE:BOOL=OFF",
                            "-DLUA_INCLUDE_DIR=#{lua.opt_include}/lua#{luaversion}",
                            "-DLUA_LIBRARY=#{lua.opt_lib}/liblua.#{luaversion}.dylib",
                            *std_cmake_args
      system "make"
      system "make", "install"
    end
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
