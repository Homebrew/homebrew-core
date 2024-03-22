class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "http://project-osrm.org/"
  license "BSD-2-Clause"
  revision 4
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  stable do
    url "https://github.com/Project-OSRM/osrm-backend/archive/refs/tags/v5.27.1.tar.gz"
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
    sha256 cellar: :any,                 arm64_sonoma:   "caf7f16eca550f4d6ee0489da25bf1424d1b502d1d6b857fec32a949b5eccd4c"
    sha256 cellar: :any,                 arm64_ventura:  "1e2a9f3bdbe82b4829e1ede3055e01723c41a173cddb5d844b786f6e067997d6"
    sha256 cellar: :any,                 arm64_monterey: "2ec4be7416632841b0ab975bf3ee19955a0553dc29f3688a7490e074500c1b7e"
    sha256 cellar: :any,                 sonoma:         "5ff2a490bd7c37b84a0950d6723fe8f26dc32c4c3dfcdaacd86f2408021a18c5"
    sha256 cellar: :any,                 ventura:        "c09c5ac0b43ce8522733109e5058f0bdc6a1263ebb63f12f31707d16125fb342"
    sha256 cellar: :any,                 monterey:       "7cc4db1f0e503ec4c4c638f8d1af5f59b3b5cd446ef823eadfda27d5323bb1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d5c85b00c8c3508407531ad72704f8c4b4211ce7c401d103ac37dbcc9c9e249"
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

