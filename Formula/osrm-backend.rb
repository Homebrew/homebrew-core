class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/v5.4.1.tar.gz"
  sha256 "7b0a95d2061e66d12b54e088ad899aa745995b9b3bf1916960cbdf6a89fb9ee3"

  bottle do
    cellar :any
    sha256 "0ea0c9be72339e12711889ce65011784b32a8f8301d308e8139d5f63bb794a9f" => :sierra
    sha256 "587bb9bd26d107334b4fddb852e0e0599b9ff85c8df9255265567df0a0831d4f" => :el_capitan
    sha256 "3e84fa659f49edff978c4245c44b830553c1f609f9323a0ec68f3f5ec911f96e" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cmake"
  depends_on "libstxxl"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua51"
  depends_on "luabind"
  depends_on "tbb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.osm").write <<-EOS.undent
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

    (testpath/"tiny-profile.lua").write <<-EOS.undent
    function way_function (way, result)
      result.forward_mode = mode.driving
      result.forward_speed = 1
    end
    EOS
    safe_system "#{bin}/osrm-extract", "test.osm", "--profile", "tiny-profile.lua"
    safe_system "#{bin}/osrm-contract", "test.osrm"
    assert File.exist?("#{testpath}/test.osrm"), "osrm-extract generated no output!"
  end
end
