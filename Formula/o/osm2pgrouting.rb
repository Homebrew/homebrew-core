class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 16
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8d5da6cbb1019f6896dcd1c2ec6b5b85364f5ab8e1eaf03faa363a9ac741f708"
    sha256 cellar: :any,                 arm64_sonoma:  "07719354b8de8ec105fb5fff9b6f5555af88d5fa25b2c740669beb753d4d879d"
    sha256 cellar: :any,                 arm64_ventura: "5c8c6568d0a0a8b8e2e702fbaeef2423d56e6da413a39aab02d6247da9c8bce3"
    sha256 cellar: :any,                 sonoma:        "e062d6e09ecbd479fbd21d8abfa972dcb0fffb463ad2f80e0cddbc844304ac6b"
    sha256 cellar: :any,                 ventura:       "db7de5922d67e005b7f007b8a00448e668dcf292766858c8415e52f5301592a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac2b94e89037e79c0faa8acbf0d4f702f03d55905be7a0edf452c2eebf6b9408"
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
