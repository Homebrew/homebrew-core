class OsrmBackend < Formula
  desc "High performance routing engine"
  homepage "https://project-osrm.org/"
  license "BSD-2-Clause"
  revision 6
  head "https://github.com/Project-OSRM/osrm-backend.git", branch: "master"

  # TODO: Remove `conflicts_with "mapnik"` in release that has following commit:
  # https://github.com/Project-OSRM/osrm-backend/commit/c1ed73126dd467171dc7adb4ad07864909bcb90f
  stable do
    url "https://github.com/Project-OSRM/osrm-backend/archive/refs/tags/v5.27.1.tar.gz"
    sha256 "52391580e0f92663dd7b21cbcc7b9064d6704470e2601bf3ec5c5170b471629a"

    # Backport fix for missing include. Remove in the next release.
    # Ref: https://github.com/Project-OSRM/osrm-backend/commit/565959b3896945a0eb437cc799b697be023121ef
    #
    # Also add temporary build fix to 'include/util/lua_util.hpp' for Boost 1.85.0.
    # Issue ref: https://github.com/Project-OSRM/osrm-backend/issues/6850
    #
    # Also backport sol2.hpp workaround to avoid a Clang bug. Remove in the next release
    # Ref: https://github.com/Project-OSRM/osrm-backend/commit/523ee762f077908d03b66d0976c877b52adf22fa
    patch :DATA
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ea5f99145c4fe841d95fba33e08a093f88b291e311e219b0b833fd9777caeb9e"
    sha256 cellar: :any,                 arm64_sonoma:   "650d17a3915469c4bbd23eec83f8ceb27570b0d3207c1a3598f3d6747296c21e"
    sha256 cellar: :any,                 arm64_ventura:  "ccd438e39cdec24fdff74bb2ed43cee49d00af2b3144ad90802fa3e3bb53eb79"
    sha256 cellar: :any,                 arm64_monterey: "072bd2264dec2d9db23593505666eb8b67b5f993d5753a67decae862be2b5330"
    sha256 cellar: :any,                 sonoma:         "2fd84b9de2a0e5f091371d7480b8cc2fa0296d71e5f910291e8e293b00e26523"
    sha256 cellar: :any,                 ventura:        "c34da972144b065eb8bcd678359b298c63631052fce4dfd2565042d77a9e7fd7"
    sha256 cellar: :any,                 monterey:       "0883df366fab00865ab4f9b83a0879d73006abbcd0856c0f27165d631f79269e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8d9c984c196e0eba61bb632babccb693d2a5e1bb49864d6656a3bf64c6eef51"
  end

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "libstxxl"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"
  depends_on "tbb"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  conflicts_with "flatbuffers", because: "both install flatbuffers headers"
  conflicts_with "mapnik", because: "both install Mapbox Variant headers"

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

    safe_system bin/"osrm-extract", "test.osm", "--profile", "tiny-profile.lua"
    safe_system bin/"osrm-contract", "test.osrm"
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

diff --git a/third_party/sol2-3.3.0/include/sol/sol.hpp b/third_party/sol2-3.3.0/include/sol/sol.hpp
index 8b0b7d36ea4ef2a36133ce28476ae1620fcd72b5..d7da763f735434bf4a40b204ff735f4e464c1b13 100644
--- a/third_party/sol2-3.3.0/include/sol/sol.hpp
+++ b/third_party/sol2-3.3.0/include/sol/sol.hpp
@@ -19416,7 +19416,14 @@ namespace sol { namespace function_detail {
 		}

 		template <bool is_yielding, bool no_trampoline>
-		static int call(lua_State* L) noexcept(std::is_nothrow_copy_assignable_v<T>) {
+		static int call(lua_State* L)
+// see https://github.com/ThePhD/sol2/issues/1581#issuecomment-2103463524
+#if SOL_IS_ON(SOL_COMPILER_CLANG)
+		// apparent regression in clang 18 - llvm/llvm-project#91362
+#else
+			noexcept(std::is_nothrow_copy_assignable_v<T>)
+#endif
+		{
 			int nr;
 			if constexpr (no_trampoline) {
 				nr = real_call(L);
@@ -19456,7 +19463,14 @@ namespace sol { namespace function_detail {
 		}

 		template <bool is_yielding, bool no_trampoline>
-		static int call(lua_State* L) noexcept(std::is_nothrow_copy_assignable_v<T>) {
+		static int call(lua_State* L)
+// see https://github.com/ThePhD/sol2/issues/1581#issuecomment-2103463524
+#if SOL_IS_ON(SOL_COMPILER_CLANG)
+		// apparent regression in clang 18 - llvm/llvm-project#91362
+#else
+			noexcept(std::is_nothrow_copy_assignable_v<T>)
+#endif
+		{
 			int nr;
 			if constexpr (no_trampoline) {
 				nr = real_call(L);
