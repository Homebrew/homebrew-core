class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.27.0.tar.gz"
  sha256 "d69be456efd999a8ace0f8df5ea017d4020b6bd806602d94024461f1ac36fe41"
  license "EPL-1.0"
  revision 2
  head "https://github.com/planck-repl/planck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c731aea9cb0275695b209bb5084210afd6a0e9a5e67c8e9efec9a13a1b2e9518"
    sha256 cellar: :any,                 arm64_monterey: "1f4b0e70f38857049b419ccff92ac1a14f021789f781e29d9e289d8efd260cde"
    sha256 cellar: :any,                 arm64_big_sur:  "31ce144c77bacf764cda0691e55d5e252de259b8e06a47a09230f7bb90f8b87f"
    sha256 cellar: :any,                 ventura:        "c45d560dfe371e1da07165c220cd0df5cd271049d1767301f21b44a3f1cd0c6e"
    sha256 cellar: :any,                 monterey:       "6cfca8f70816b1fda8316c2fbc2c78c781968890e31ee1c3afc358dc5dc4fdc4"
    sha256 cellar: :any,                 big_sur:        "a5846446249d8101ac5fd2b92bd2af291d908be3f0437b469ed1435fcb878d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "426d25fd74343b3736c67c93f2f0e51499d4699f82473ec04916416b7544c5de"
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "icu4c"
  depends_on "libzip"

  uses_from_macos "vim" => :build # for xxd
  uses_from_macos "curl"
  uses_from_macos "libffi"

  on_linux do
    depends_on "glib"
    depends_on "pcre"
    depends_on "webkitgtk"
  end

  fails_with gcc: "5"

  # Don't mix our ICU4C headers with the system `libicucore`.
  # TODO: Upstream this.
  patch :DATA

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

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
