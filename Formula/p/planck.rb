class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  license "EPL-1.0"
  revision 3
  head "https://github.com/planck-repl/planck.git", branch: "master"

  stable do
    url "https://github.com/planck-repl/planck/archive/refs/tags/2.28.0.tar.gz"
    sha256 "44f52e170d9a319ec89d3f7a67a7bb8082354f3da385a83bd3c7ac15b70b9825"

    # Backport fix for CMake 4
    patch do
      url "https://github.com/planck-repl/planck/commit/0e336f722b52f18e130d3866d4c512b20bafcbd7.patch?full_index=1"
      sha256 "685fb05b666f5ed419d986be6a35bda6448f062eaeb6666a9910a2c4dd4fd16a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "94dbee8e25f82b3d6af4c0f5aa768b072b5f42c37c17a6ee55820a6c3e9a9210"
    sha256 cellar: :any,                 arm64_sonoma:  "9b48ec0e76cc42f5a7bcee1704e043b6ee37cecbcc65acc9f9926367cb99b54a"
    sha256 cellar: :any,                 arm64_ventura: "698191a3c5a7d477a3d21bd0f7638b67fbc34c8d71b69fa44d5814dcc842ac2b"
    sha256 cellar: :any,                 sonoma:        "1569b2fbd7b63d35aa7a8c86df20494825214a1b66e5f789cbf4c72c3a595560"
    sha256 cellar: :any,                 ventura:       "bc7daa8d9acfdf57759f78bacf47c2f5d03843bfb9885e29f87c288dfeee2c44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "454bc28f6cdd3a17ec9019e262b7af06a8970dfdef59850c371ae8a2922d0e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f833bad418d1787df2686c970188abd9dfad3657707a309827773253dfa5487b"
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "icu4c@77"
  depends_on "libzip"

  uses_from_macos "vim" => :build # for xxd
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "webkitgtk"
  end

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
