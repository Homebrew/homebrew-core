class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/refs/tags/2.28.0.tar.gz"
  sha256 "44f52e170d9a319ec89d3f7a67a7bb8082354f3da385a83bd3c7ac15b70b9825"
  license "EPL-1.0"
  revision 2
  head "https://github.com/planck-repl/planck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab34e0ef0e2e78aa190ca2ba821bd8e4ccfc7f4ba3b79fc1d7a74c697095512e"
    sha256 cellar: :any,                 arm64_sonoma:  "96f747019fe7702ddf88fa4d7d2267b6031436df2417073f3bbcabb8c6b5d66d"
    sha256 cellar: :any,                 arm64_ventura: "342f71f4a83296fa7754cc6244c4979a8976f0a4a5a6ea1ebad661ad6d6e329e"
    sha256 cellar: :any,                 sonoma:        "d8d0fd48c44530bc3ef14f7eaa733c596356a686c6acba27da55224a936d0172"
    sha256 cellar: :any,                 ventura:       "0ed48e120f059d43836251a16464488a85e46826a428838317bdef1bda516bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f73054a3ff20c391c8f63196e146ff267143c1c3f72a4177d205f63bd2a1aa6"
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "icu4c@76"
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
