class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 17
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "923a96fe6f095a29899a9a4099bf16f518e02ffb4f9960dbc2e814ed146f46c3"
    sha256 cellar: :any,                 arm64_sequoia: "98b32784353c589877d2c2f192a879df3699aef5715bebddd9ce17b1d0af22d3"
    sha256 cellar: :any,                 arm64_sonoma:  "3b7e79d8ba1e24d0a54a528e40c8c0117e844874dbe07541758c2b7b9880af72"
    sha256 cellar: :any,                 arm64_ventura: "1488bde56531bd16ca795364651236755b3f2549a60db5b566ff3ea2f4cc6d12"
    sha256 cellar: :any,                 sonoma:        "e07980e3e300a819dd87ff80f87034a4423fce2e2fc3b9a0c8126025c32ec276"
    sha256 cellar: :any,                 ventura:       "64fa667af838151ab67056f402a3d50a1145a9a146cd4b9e0f80c6ed7659880e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84b05e22f51e109013269732427342871cf46b73a629a3a95ce03b8f754361f8"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"

  uses_from_macos "expat"

  # Fix build failure due to missing include
  # src/osm_elements/osm_tag.cpp:34:18: error: 'transform' is not a member of 'std'
  patch :DATA

  # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
  # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
  # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
  def remove_brew_expat
    env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
    ENV.remove env_vars, /(^|:)#{Regexp.escape(Formula["expat"].opt_prefix)}[^:]*/
    ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
  end

  def install
    remove_brew_expat if OS.mac? && MacOS.version < :sequoia

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
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
