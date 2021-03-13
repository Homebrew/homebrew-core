class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/v5.25.0.tar.gz"
  sha256 "6da276d609a54600bb37007fd98d14c2a48639f51dda0d962b5801dd0118dfbb"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Project-OSRM/osrm-backend.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dc65b0d0046277182590cc6d3b16b5436a637a0c87d0d6ca3b81bf4ee4aa138a"
    sha256 cellar: :any, big_sur:       "5d461962ca9a86f733ee2223080fd63c9ef1bd1c0fbd6820d29dfe1ba46b1f75"
    sha256 cellar: :any, catalina:      "07166bddc5e210fd5c697c9dd168667522c83260c143a2f956dcf079507e0141"
    sha256 cellar: :any, mojave:        "002af11b6c8a248e91417f997eb13d9a6a624bbd34795ba961ff48e184f872a5"
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
