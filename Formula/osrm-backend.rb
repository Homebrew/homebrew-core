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
    sha256 cellar: :any, arm64_big_sur: "4f459e02861a2bd1f069f4e4eaf5d067c3f8533c45f05e5d92e3485ba6eed0de"
    sha256 cellar: :any, big_sur:       "9503f806b2f88daf95a054754e3fcee7c49cb4e89414d1ff18452b476ea80cf1"
    sha256 cellar: :any, catalina:      "a28c8d9695583ead07fc870472a2701ff9702493147f04467e73371899e88abd"
    sha256 cellar: :any, mojave:        "1a2240493d43b788bd4c5e0018ed8fa076833b28068364806a9ef9754323a84a"
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
