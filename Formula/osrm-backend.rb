class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/v5.12.0.tar.gz"
  sha256 "b89137ba0c22af9babe0d87b226c68412ccf7919bbe02265a159c53f84a9ca2b"
  head "https://github.com/Project-OSRM/osrm-backend.git"

  bottle do
    cellar :any
    sha256 "9e3de1eb89b1ef0bf886199fe7c393d2cfac73758a157a7126290d05280c826c" => :high_sierra
    sha256 "e23ed530b166528ff281f1bccb95a8a785e052e15b134a8d576ecc36907cbc5a" => :sierra
    sha256 "ba0efa37c4e6f06e5a0a2eacc1233a5d5487d87491417f70aca0e079cc2064d3" => :el_capitan
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
