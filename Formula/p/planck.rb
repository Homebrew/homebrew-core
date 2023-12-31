class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/refs/tags/2.27.0.tar.gz"
  sha256 "d69be456efd999a8ace0f8df5ea017d4020b6bd806602d94024461f1ac36fe41"
  license "EPL-1.0"
  revision 2
  head "https://github.com/planck-repl/planck.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "8fda29d5f8dd36e6b05b1dffa3fe70e88f8377f540c161166eb79d3f40f5b9d8"
    sha256 cellar: :any,                 arm64_ventura:  "c88241e7e506de46a27e221ed755db3c63e29f5dd94f12257b35f8e38cb9b2ea"
    sha256 cellar: :any,                 arm64_monterey: "90dad05fabfdd7cbd4239c04f3db400ae1fa270523da515054288ce15a839e25"
    sha256 cellar: :any,                 sonoma:         "817ae563b1a4fdd70e36e76be7d3f9ef041a35bffa7c6ac776fcb00b4fac3f08"
    sha256 cellar: :any,                 ventura:        "f030bda901045014db5359209b18c9a2739c5579e3faf69af27f116d4d4f8a22"
    sha256 cellar: :any,                 monterey:       "b1d9f917b6e6a679645f8659b27adbf4fef08212bdfbfdad673ab6ec29d1eaea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5107a41edde7c77929e24faa9919f8536228b6d08babaf7a1b28a371fafddc7d"
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
