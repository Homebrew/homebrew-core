class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.0/cpp/avro-cpp-1.12.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.0/cpp/avro-cpp-1.12.0.tar.gz"
  sha256 "f2edf77126a75b0ec1ad166772be058351cea3d74448be7e2cef20050c0f98ab"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6704d6e89acb0c747ea276845a9931aba6be8ccb0555ea7333f6fd871d33ef74"
    sha256 cellar: :any,                 arm64_sequoia: "c957d98325e78e380f0350d9c9e96edd4dedf5bc6e066cd3e1cc8149b50c8598"
    sha256 cellar: :any,                 arm64_sonoma:  "b099c4cb40748b37a98350b66ecfaeeca27028731698f061a943aa677cea409b"
    sha256 cellar: :any,                 arm64_ventura: "2bd5f3b4db84283a53fd5ad1378e64fe2be612ba26d542eef7678de2c3a9bc39"
    sha256 cellar: :any,                 sonoma:        "1f97c3b6d551ac12a5709fc8677c5f9383d82f592a55884009fefd14f1c86829"
    sha256 cellar: :any,                 ventura:       "ec11016e755c1c5ccae51e3e6f443a5051ace8c0649129102d047150fada63dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06cd6e6715712951deb88a37597234c495bf65fe08eb54a8b74310007780ac32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae8f2eb793dc55a6deb6907c02445d54feb481060a4c0fdc8bbbbdd3cfb3737"
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
