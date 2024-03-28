class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/refs/tags/2.28.0.tar.gz"
  sha256 "44f52e170d9a319ec89d3f7a67a7bb8082354f3da385a83bd3c7ac15b70b9825"
  license "EPL-1.0"
  head "https://github.com/planck-repl/planck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d191a614bd84bcc9d260923fa40aeaa05519773c758f2731fc12724c478a9b40"
    sha256 cellar: :any,                 arm64_ventura:  "417db2a6168646c53b8bf748fc8920c97f41e362e463042fad5548106ae0b235"
    sha256 cellar: :any,                 arm64_monterey: "a2d86b54405f284660eeb8199488b1892747d60aafdc453598d85cc8b2ddd84d"
    sha256 cellar: :any,                 sonoma:         "2ea02808fba9f62cb10fa592381cbce8c2a737b3c634bcc6eaec1c94f4566633"
    sha256 cellar: :any,                 ventura:        "26434fb97e32d2e244d5964e061ae7706ca416fafe6c4600c33548b5bb35f554"
    sha256 cellar: :any,                 monterey:       "baa4b152e861f9f1579e64a84c925970a9a813c15d2006da864eeed74383016c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "716444d924733adfecb5382de8260cdc0537b49afee6e4a2622a49d1da4853c1"
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
