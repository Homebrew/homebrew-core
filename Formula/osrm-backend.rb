class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/v5.26.0.tar.gz"
  sha256 "45e986db540324bd0fc881b746e96477b054186698e8d14610ff7c095e906dcd"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "4a88710e2228747584c05029032b01ec71634bc470487c3da79d8e374fe12ffa"
    sha256 cellar: :any, arm64_big_sur:  "273e540157c193740db4b9490bd4da38261b8479ff9b40431545d72c5507696e"
    sha256 cellar: :any, monterey:       "d74e62b2ffba6f19c1995da7548881c71b054693763a620488d510b8b0dfeb9d"
    sha256 cellar: :any, big_sur:        "170a08f79eafd445d62ccf687bbdee628380c3b836739bf8fc0b7fcb8d5e3bb7"
    sha256 cellar: :any, catalina:       "71573db82a0f2c535e3a391c112ed29d6002b1f26f9bc9835be004dd99735079"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libstxxl"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"
  depends_on "tbb@2020"

  conflicts_with "flatbuffers", because: "both install flatbuffers headers"

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
