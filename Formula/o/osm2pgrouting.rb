class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 13
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "65d7687ba5f23d47d7ee737050706fcd2663cf185d6a8e35a6e8e6ff5cec2d87"
    sha256 cellar: :any, arm64_ventura:  "88adc64e52319b44b1f3f0e73d9511a3e36db0040859d9b528aa76a02570666d"
    sha256 cellar: :any, arm64_monterey: "81565a691a1f95000e45594e0f7c938d7960694c5e4722d013bc4fe4c54401ca"
    sha256 cellar: :any, sonoma:         "1b1702478ac4b650960b2227dd605dc84a6e8d15c5da96d3973a700545425bfc"
    sha256 cellar: :any, ventura:        "ed29492dadc022e58bb198e7ab20871d3c45272abacbd99d7c350c13d6ae0995"
    sha256 cellar: :any, monterey:       "0f7cdcc3eb7ddbabf32a02836a733e709a0ebbcd0e4158316536daebf8b67246"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"

  fails_with gcc: "5"

  # Fix build failure due to missing include
  # src/osm_elements/osm_tag.cpp:34:18: error: 'transform' is not a member of 'std'
  patch :DATA

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(/^llvm(@\d+)?$/) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end

__END__
diff --git a/src/osm_elements/osm_tag.cpp b/src/osm_elements/osm_tag.cpp
index 6f122ec..b41d6ff 100644
--- a/src/osm_elements/osm_tag.cpp
+++ b/src/osm_elements/osm_tag.cpp
@@ -20,6 +20,7 @@


 #include "osm_elements/osm_tag.h"
+#include <algorithm>
 #include <string>

 namespace osm2pgr {
