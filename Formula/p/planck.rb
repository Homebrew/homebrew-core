class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  license "EPL-1.0"
  revision 4
  head "https://github.com/planck-repl/planck.git", branch: "master"

  stable do
    url "https://github.com/planck-repl/planck/archive/refs/tags/2.28.0.tar.gz"
    sha256 "44f52e170d9a319ec89d3f7a67a7bb8082354f3da385a83bd3c7ac15b70b9825"

    # Backport fix for CMake 4
    patch do
      url "https://github.com/planck-repl/planck/commit/0e336f722b52f18e130d3866d4c512b20bafcbd7.patch?full_index=1"
      sha256 "685fb05b666f5ed419d986be6a35bda6448f062eaeb6666a9910a2c4dd4fd16a"
      type :backport
      resolves "https://github.com/planck-repl/planck/pull/1107"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "15312160f296c470e753ce95989e3d1497adc4d33b4a3392fb0fbb7bc7ae423b"
    sha256 cellar: :any, arm64_tahoe:       "8ae97ba5cca0b1d7393afeebb403e25821a75a1e3ab054313a6031ac9b3530e4"
    sha256 cellar: :any, arm64_sequoia:     "5ccf43cd6bcffc657596beddd703a69d6aabc4437b3e5945a20cb88f55f1999d"
    sha256 cellar: :any, arm64_sonoma:      "c7c752a3b624660fd894e37e4bf7e37c2b4e69b399fe82849a9c68e2d8bb6fb5"
    sha256 cellar: :any, arm64_linux:       "317b3cac73e97f287c4643983c9caa62f99dec3cdbeb535e156b1472339f1db2"
    sha256 cellar: :any, x86_64_linux:      "7b58c81a2330e003de4ee7329a0cfe6f83811e83bdbd0dc51e9c82bbac8079cb"
  end

  deprecate! date: "2026-02-21", because: :unmaintained
  disable! date: "2027-02-21", because: :unmaintained

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "libzip"

  uses_from_macos "vim" => :build # for xxd
  uses_from_macos "curl"

  on_macos do
    depends_on xcode: :build
  end

  on_linux do
    depends_on "webkitgtk"
    depends_on "zlib-ng-compat"
  end

  # Don't mix our ICU4C headers with the system `libicucore`.
  # TODO: Upstream this.
  patch :DATA

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    if OS.linux?
      ENV.prepend_path "PATH", formula_opt_bin("openjdk")

      # The webkitgtk pkg-config .pc file includes the API version in its name (ex. javascriptcore-4.1.pc).
      # We extract this from the filename programmatically and store it in javascriptcore_api_version
      # and make sure planck-c/CMakeLists.txt is updated accordingly.
      # On macOS this dependency is provided by JavaScriptCore.Framework, a component of macOS.
      javascriptcore_pc_file = formula_opt_lib("webkitgtk").glob("pkgconfig/javascriptcoregtk-*.pc").first
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
