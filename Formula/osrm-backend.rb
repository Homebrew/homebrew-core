class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/v5.24.0.tar.gz"
  sha256 "a66b20e7ffe83e5e5fe12324980320e12a6ec2b05f2befd157de5c60c665613c"
  license "BSD-2-Clause"
  head "https://github.com/Project-OSRM/osrm-backend.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fe1d2680e22150a35b6d5c76157c867e3faed556bb127fe2b57eff79858ac668"
    sha256 cellar: :any, big_sur:       "e6dfd1fc4adacbf0b54be1b1c10218fa18b6ea186ea802df3791a023b95f5705"
    sha256 cellar: :any, catalina:      "fd6cad0c66a91a963006b7f961d3fbdce9d4ecf47acb4c578f23602f8025512e"
    sha256 cellar: :any, mojave:        "b4dd6eb3f99a2caf3f733beb93046bb69813a3b3b32cb73410527b03e20a5c93"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libstxxl"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"
  depends_on "tbb"

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
