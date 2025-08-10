class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.0/cpp/avro-cpp-1.12.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.0/cpp/avro-cpp-1.12.0.tar.gz"
  sha256 "f2edf77126a75b0ec1ad166772be058351cea3d74448be7e2cef20050c0f98ab"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "35545fc4240e13f8631fe71b1a9469092c15e2793c0d106d14fb34533db0e84b"
    sha256 cellar: :any,                 arm64_sonoma:  "23c9ec83f2944a1d29735e620a4f64b7e0d9d94326c6dc9633383cfd53ebbecb"
    sha256 cellar: :any,                 arm64_ventura: "425d77362d151dc0cb07d97bf7dc3588f340f568c8b5fcb23377f61510e47ea5"
    sha256 cellar: :any,                 sonoma:        "82b98ee513025822b480a023234fe08f4f8d57fcab9b561c653562cde087c6a4"
    sha256 cellar: :any,                 ventura:       "c04f7eef9843de29ca88223e70476d221cf017313b558c544bd4f47dc403c72d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22e8f9ba754a3dd5ed7ec1fe95b0c79b859bb9aa7fe95abc9f3340c7e8bda79d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4c9fcfa73b1edfe173bd96bd36844029d48614ed5e8934498a2b67329da5183"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => [:build, :test] # needed for headers
  depends_on "pkgconf" => :build
  depends_on "boost"

  # Fix compatibility with `fmt` 11, https://github.com/apache/avro/pull/3444
  # Fix to use system installed `fmt`, https://github.com/apache/avro/pull/3447
  # Both patches are not applicable to the source splitted tarball
  # Also add workaround for Boost 1.89.0 until next release that drops Boost dep
  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"cpx.json").write <<~JSON
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    JSON

    (testpath/"test.cpp").write <<~CPP
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    CPP

    system bin/"avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 19059a4..afdfdf5 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -80,17 +80,20 @@ endif ()
 
 
 find_package (Boost 1.38 REQUIRED
-    COMPONENTS filesystem iostreams program_options regex system)
-
-include(FetchContent)
-FetchContent_Declare(
-        fmt
-        GIT_REPOSITORY  https://github.com/fmtlib/fmt.git
-        GIT_TAG         10.2.1
-        GIT_PROGRESS    TRUE
-        USES_TERMINAL_DOWNLOAD TRUE
-)
-FetchContent_MakeAvailable(fmt)
+    COMPONENTS filesystem iostreams program_options regex)
+
+find_package(fmt)
+if (NOT fmt_FOUND)
+    include(FetchContent)
+    FetchContent_Declare(
+            fmt
+            GIT_REPOSITORY  https://github.com/fmtlib/fmt.git
+            GIT_TAG         10.2.1
+            GIT_PROGRESS    TRUE
+            USES_TERMINAL_DOWNLOAD TRUE
+    )
+    FetchContent_MakeAvailable(fmt)
+endif (NOT fmt_FOUND)
 
 find_package(Snappy)
 if (SNAPPY_FOUND)
diff --git a/include/avro/Node.hh b/include/avro/Node.hh
index f76078b..7226d05 100644
--- a/include/avro/Node.hh
+++ b/include/avro/Node.hh
@@ -219,7 +219,7 @@ inline std::ostream &operator<<(std::ostream &os, const avro::Node &n) {
 template<>
 struct fmt::formatter<avro::Name> : fmt::formatter<std::string> {
     template<typename FormatContext>
-    auto format(const avro::Name &n, FormatContext &ctx) {
+    auto format(const avro::Name &n, FormatContext &ctx) const {
         return fmt::formatter<std::string>::format(n.fullname(), ctx);
     }
 };
diff --git a/include/avro/Types.hh b/include/avro/Types.hh
index 84a3397..c0533f3 100644
--- a/include/avro/Types.hh
+++ b/include/avro/Types.hh
@@ -113,7 +113,7 @@ std::ostream &operator<<(std::ostream &os, const Null &null);
 template<>
 struct fmt::formatter<avro::Type> : fmt::formatter<std::string> {
     template<typename FormatContext>
-    auto format(avro::Type t, FormatContext &ctx) {
+    auto format(avro::Type t, FormatContext &ctx) const {
         return fmt::formatter<std::string>::format(avro::toString(t), ctx);
     }
 };
