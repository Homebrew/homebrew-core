class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/v5.16.4.tar.gz"
  sha256 "c2b014cfa65deee0b8ee2c94893362951ebc42684710fa8d9f3d1ecfeb927da4"
  head "https://github.com/Project-OSRM/osrm-backend.git"

  bottle do
    cellar :any
    sha256 "d770a22d07f0d8ce62e9a9bf5b68ba0279277e0ae4474764689f7b6032015e35" => :high_sierra
    sha256 "a55181a3725810c1e499bed0d12ece25ff35a8041014ac16aad7a97e282d1b45" => :sierra
    sha256 "0216d5a4752ff45fea6546fd57c24f60f98738dcc0b0310893a9d11df81d5318" => :el_capitan
  end

  # "invalid use of non-static data member 'offset'"
  # https://github.com/Project-OSRM/osrm-backend/issues/3719
  depends_on :macos => :el_capitan

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libstxxl"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"
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
    (testpath/"test.osm").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <osm version="0.6">
       <bounds minlat="54.0889580" minlon="12.2487570" maxlat="54.0913900" maxlon="12.2524800"/>
       <node id="1" lat="54.0901746" lon="12.2482632" user="a" uid="46882" visible="true" version="1" changeset="676636" timestamp="2008-09-21T21:37:45Z"/>
       <node id="2" lat="54.0906309" lon="12.2441924" user="a" uid="36744" visible="true" version="1" changeset="323878" timestamp="2008-05-03T13:39:23Z"/>
       <node id="3" lat="52.0906309" lon="12.2441924" user="a" uid="36744" visible="true" version="1" changeset="323878" timestamp="2008-05-03T13:39:23Z"/>
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
