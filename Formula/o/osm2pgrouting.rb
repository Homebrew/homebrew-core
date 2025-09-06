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
    sha256 cellar: :any,                 arm64_sequoia: "14fb9c2006e86553e4d41bd2f51bf9e1a1bfaa417568ff0ecb0fa43deaf3c493"
    sha256 cellar: :any,                 arm64_sonoma:  "a5f667c57e12e3d40f0c5299b2f409fc8b97bf1a7ecc35176effb72db7fecb5b"
    sha256 cellar: :any,                 arm64_ventura: "67c2f5cafb319a50c79aa142585d1dc7c7ccd722979bb73933af3bdfa9a5eba2"
    sha256 cellar: :any,                 sonoma:        "2e5b3b6b47c1dbd612d1b277bbf0028ff98100aee1eb01cdf4d0cb6ba3781077"
    sha256 cellar: :any,                 ventura:       "8f7219980749e1d34008b5e003fe242d126a644f338857ce45b80e65e5444cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "974b9e601d21160fe5a186447872f943398b7579553eeb3fe522904dcd9746a2"
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
