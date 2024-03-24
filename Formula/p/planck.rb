class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/refs/tags/2.28.0.tar.gz"
  sha256 "44f52e170d9a319ec89d3f7a67a7bb8082354f3da385a83bd3c7ac15b70b9825"
  license "EPL-1.0"
  head "https://github.com/planck-repl/planck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ff3ca72b2b4cf469eb4319d31a45784ecdf4943a99e65b7cf1b0644f679f9da"
    sha256 cellar: :any,                 arm64_ventura:  "970c6f4dd5346c0acf49d25fdc2256ad3553b5ad646a347c99765510cf517b53"
    sha256 cellar: :any,                 arm64_monterey: "3545c08d8d72de0a809fdc78db7a3b062e813dc760d5e23cafcc9c469171539d"
    sha256 cellar: :any,                 sonoma:         "2078414c6bedde4348454315bf808b1df07f4d6e5898626465591daa2191a944"
    sha256 cellar: :any,                 ventura:        "1740760a4e914f41546f3bb1b4d7eaa0594a9492a73e20843da76b715c10a02b"
    sha256 cellar: :any,                 monterey:       "7aabe1b076a404ebf5f5795413b4ce92b661981140d7445885856020d9d555d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffce7a73a0e99520998c61c87c42606c387ab78f57734f1dc7d172821997e865"
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "icu4c"
  depends_on "libzip"

  uses_from_macos "vim" => :build # for xxd
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "webkitgtk"
  end

  fails_with gcc: "5"

  # Don't mix our ICU4C headers with the system `libicucore`.
  # TODO: Upstream this.
  patch :DATA

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    if OS.linux?
      ENV.prepend_path "PATH", Formula["openjdk"].opt_bin

      # The webkitgtk pkg-config .pc file includes the API version in its name (ex. javascriptcore-4.1.pc).
      # We extract this from the filename programmatically and store it in javascriptcore_api_version
      # and make sure planck-c/CMakeLists.txt is updated accordingly.
      # On macOS this dependency is provided by JavaScriptCore.Framework, a component of macOS.
      javascriptcore_pc_file = (Formula["webkitgtk"].lib/"pkgconfig").glob("javascriptcoregtk-*.pc").first
      javascriptcore_api_version = javascriptcore_pc_file.basename(".pc").to_s.split("-").second
      inreplace "planck-c/CMakeLists.txt", "javascriptcoregtk-4.0", "javascriptcoregtk-#{javascriptcore_api_version}"
    end

    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
    bin.install "planck-sh/plk"
    man1.install Dir["planck-man/*.1"]
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end

__END__
diff --git a/planck-c/CMakeLists.txt b/planck-c/CMakeLists.txt
index ec0dd3a..9bf1496 100644
--- a/planck-c/CMakeLists.txt
+++ b/planck-c/CMakeLists.txt
@@ -104,17 +104,12 @@ elseif(UNIX)
     target_link_libraries(planck ${JAVASCRIPTCORE_LDFLAGS})
 endif(APPLE)
 
-if(APPLE)
-   add_definitions(-DU_DISABLE_RENAMING)
-   include_directories(/usr/local/opt/icu4c/include)
-   find_library(ICU4C icucore)
-   target_link_libraries(planck ${ICU4C})
-elseif(UNIX)
+if(UNIX)
    pkg_check_modules(ICU_UC REQUIRED icu-uc)
    pkg_check_modules(ICU_IO REQUIRED icu-io)
    include_directories(${ICU_UC_INCLUDE_DIRS} ${ICU_IO_INCLUDE_DIRS})
    target_link_libraries(planck ${ICU_UC_LDFLAGS} ${ICU_IO_LDFLAGS})
-endif(APPLE)
+endif(UNIX)
 
 if(APPLE)
 elseif(UNIX)
