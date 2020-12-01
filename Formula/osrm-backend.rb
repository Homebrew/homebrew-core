class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  url "https://github.com/Project-OSRM/osrm-backend/archive/v5.23.0.tar.gz"
  sha256 "8527ce7d799123a9e9e99551936821cc0025baae6f2120dbf2fbc6332c709915"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Project-OSRM/osrm-backend.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "7d02de23033c49becaf6aff9a416af9018a9e5ab2e23088bc8e82dcf860d051d" => :big_sur
    sha256 "8324eb0b1bdd716fd30f27adda229dd270ead2c34c1e58acdd2c1e8f6bc8a014" => :catalina
    sha256 "732bd127106df6dcd29480de915c3f5b577b1b33655508d6720fdad6597eb1de" => :mojave
    sha256 "6d068bf806219fc2a6173f629a48dd57831e7894f21ec38eaf859fbc8fa9b250" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libstxxl"
  depends_on "libxml2"
  depends_on "libzip"

  # Possible patch for lua5.4 support:
  # https://github.com/Project-OSRM/osrm-backend/pull/5783
  # Upgrade me to lua5.4 at the next version bump.
  depends_on "lua@5.3"

  # "invalid use of non-static data member 'offset'"
  # https://github.com/Project-OSRM/osrm-backend/issues/3719
  depends_on macos: :el_capitan

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
