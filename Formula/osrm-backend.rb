class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/v5.22.0.tar.gz"
  sha256 "df0987a04bcf65d74f9c4e18f34a01982bf3bb97aa47f9d86cfb8b35f17a6a55"
  revision 2
  head "https://github.com/Project-OSRM/osrm-backend.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "12ec9670281dc1918f3d22cd39fc8f710008ee729b9997d65c10b6cfd4d6de1d" => :catalina
    sha256 "db542349d5f721c7746b8222902d451828d593d7fe8d2b9235a6eb31ca3fffbc" => :mojave
    sha256 "b43652ac087d596ecb02d922a88e9fc82769bf2d8a55be424ca6102807a03e45" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libstxxl"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"

  # "invalid use of non-static data member 'offset'"
  # https://github.com/Project-OSRM/osrm-backend/issues/3719
  depends_on :macos => :el_capitan

  depends_on "tbb"

  def install
    mkdir "build" do
      system "cmake", "..", "-DENABLE_CCACHE:BOOL=OFF", *std_cmake_args
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
