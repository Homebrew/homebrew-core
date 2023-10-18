class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  stable do
    url "https://github.com/Project-OSRM/osrm-backend/archive/v5.27.1.tar.gz"
    sha256 "52391580e0f92663dd7b21cbcc7b9064d6704470e2601bf3ec5c5170b471629a"

    # Backport fix for missing include. Remove in the next release.
    # Ref: https://github.com/Project-OSRM/osrm-backend/commit/565959b3896945a0eb437cc799b697be023121ef
    patch :DATA
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8cabeea661b54d765ac785393d9f75ccfdcbcacc92647fdb8909362bdd5c7403"
    sha256 cellar: :any,                 arm64_ventura:  "44144dafdb204030ddefce66ac98e5d15c330bd98ff9397500ba9d4b65a94565"
    sha256 cellar: :any,                 arm64_monterey: "d81204f9ffcc5999aae199e93fe8eedfd48d3ed65143fa287e9bd660716da2a9"
    sha256 cellar: :any,                 arm64_big_sur:  "d48cfda368155e929f22c0cf08d1f8edee08366ebb65045b53d069fd1aeed86b"
    sha256 cellar: :any,                 sonoma:         "d46f7fa4be50de4bbddb3e7f592b4c0e6156c981e703e8d99020442d541c7018"
    sha256 cellar: :any,                 ventura:        "b68803f30785d4bc12e7a21f72b189e0918a8091f50d7b86df0d37df11b473d2"
    sha256 cellar: :any,                 monterey:       "b40166ee8b4752089e41213e9795eb90c3fb8b057f77375342669b46001c444b"
    sha256 cellar: :any,                 big_sur:        "f7468b379ec2ef34dba76e5ab90ff9bbc86a505d54493f039548b59760551787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1806109f9e7cdc92d5467d998a92190c0d15e0e9f9a2efd3e3fab633deab85b"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libstxxl"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"
  depends_on "tbb"

  uses_from_macos "expat"

  conflicts_with "flatbuffers", because: "both install flatbuffers headers"

  def install
    # Work around build failure: duplicate symbol 'boost::phoenix::placeholders::uarg9'
    # Issue ref: https://github.com/boostorg/phoenix/issues/111
    ENV.append_to_cflags "-DBOOST_PHOENIX_STL_TUPLE_H_"
    # Work around build failure on Linux:
    # /tmp/osrm-backend-20221105-7617-1itecwd/osrm-backend-5.27.1/src/osrm/osrm.cpp:83:1:
    # /usr/include/c++/11/ext/new_allocator.h:145:26: error: 'void operator delete(void*, std::size_t)'
    # called on unallocated object 'result' [-Werror=free-nonheap-object]
    ENV.append_to_cflags "-Wno-free-nonheap-object" if OS.linux?

    lua = Formula["lua"]
    luaversion = lua.version.major_minor
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_CCACHE:BOOL=OFF",
                    "-DLUA_INCLUDE_DIR=#{lua.opt_include}/lua#{luaversion}",
                    "-DLUA_LIBRARY=#{lua.opt_lib/shared_library("liblua", luaversion.to_s)}",
                    "-DENABLE_GOLD_LINKER=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    assert_predicate testpath/"test.osrm.names", :exist?, "osrm-extract generated no output!"
  end
end

__END__
diff --git a/include/extractor/suffix_table.hpp b/include/extractor/suffix_table.hpp
index 5d16fe6..2c378bf 100644
--- a/include/extractor/suffix_table.hpp
+++ b/include/extractor/suffix_table.hpp
@@ -3,6 +3,7 @@

 #include <string>
 #include <unordered_set>
+#include <vector>

 #include "util/string_view.hpp"

