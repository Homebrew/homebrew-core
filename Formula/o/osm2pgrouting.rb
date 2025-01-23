class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 15
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "53a7e3aba8bdfe9a4da235abc518b79792e53ddc141137e028388d598c58107b"
    sha256 cellar: :any,                 arm64_sonoma:  "b7834fce5a1d857f102568aeff1bed0289f37fb0ddb43151d8724ee43e5f5a66"
    sha256 cellar: :any,                 arm64_ventura: "8e9795f661e6a485111af835cd9a1564d4e1b489c708bd59bafb1d7f4fe698aa"
    sha256 cellar: :any,                 sonoma:        "be10d1bf1fb865fd1057514a75c362636e93d5ada3b2efdf98d855aed6c76494"
    sha256 cellar: :any,                 ventura:       "d2fb31aa53a17b15686bced89e3b3e30d573cf5537969612e1c5ff712638899a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "614b191dc5a642277df733a0d7c056b69f5c490ec10e44b78ed1983234e44500"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"

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
