class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  license "BSD-2-Clause"
  revision 5
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  stable do
    url "https://github.com/Project-OSRM/osrm-backend/archive/refs/tags/v5.27.1.tar.gz"
    sha256 "52391580e0f92663dd7b21cbcc7b9064d6704470e2601bf3ec5c5170b471629a"

    # Backport fix for missing include. Remove in the next release.
    # Ref: https://github.com/Project-OSRM/osrm-backend/commit/565959b3896945a0eb437cc799b697be023121ef
    #
    # Also add temporary build fix to 'include/util/lua_util.hpp' for Boost 1.85.0.
    # Issue ref: https://github.com/Project-OSRM/osrm-backend/issues/6850
    patch :DATA
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "52204e90d561f2d591adc8d37d45e5c0497190963a079a59590ddb2f5a998b88"
    sha256 cellar: :any,                 arm64_ventura:  "784500d87a1e3669bb177a2ef220e0baf6dcb521637fc8d7f5f36d5db196b38f"
    sha256 cellar: :any,                 arm64_monterey: "972fcb3717bd55b864faa779482d15439b7c60587e90c1026600e41deb227cca"
    sha256 cellar: :any,                 sonoma:         "504b122864ce2b9daebe82d03805e11a479667c861a127208029941b50373fce"
    sha256 cellar: :any,                 ventura:        "58608c37f291bfba65dde778db1e05dde5327a7c5d4a82121ba6f5b948222f5d"
    sha256 cellar: :any,                 monterey:       "d3d6dea4d4c4fc60fce90d4d4f48280ff95def4788ad5b30e4136a431e69fb08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72177707b90fc76c8f705c129f0b28b0bd958b0cfdaad4b805dc19ac90500a7a"
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

diff --git a/include/util/lua_util.hpp b/include/util/lua_util.hpp
index 36af5a1f3..cd2d1311c 100644
--- a/include/util/lua_util.hpp
+++ b/include/util/lua_util.hpp
@@ -8,7 +8,7 @@ extern "C"
 #include <lualib.h>
 }

-#include <boost/filesystem/convenience.hpp>
+#include <boost/filesystem/operations.hpp>

 #include <iostream>
 #include <string>
