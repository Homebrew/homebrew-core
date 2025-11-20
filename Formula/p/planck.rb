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
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98d3b85da67804836fdaa7db623e74ef82ab3e72ccbf8c421fa7fe7d9f16528d"
    sha256 cellar: :any,                 arm64_sequoia: "0342856b9f0638676afb22a4ba1117b942a777a17e077b808803077b7f490f7e"
    sha256 cellar: :any,                 arm64_sonoma:  "fbf8b5b7574a2e2b4470d1e90d48b1ea0006cc52f4882b301c22635bb71274b8"
    sha256 cellar: :any,                 sonoma:        "0b1b53725d302dabc755d9ee0ea2049ad1c95f292dac414c1b31b42d544e0aad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d317813fd2924a36aa989fcbd2ac729277ad0b7b0302bdfa07f4cd7c52b14bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52ba1633a236729c1ef9108e169c8bbf1bc4ca262a5cd05f67f7a2dc4f70ae37"
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "icu4c@78"
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
