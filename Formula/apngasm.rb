class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  license "Zlib"
  revision 2
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  stable do
    url "https://github.com/apngasm/apngasm/archive/3.1.6.tar.gz"
    sha256 "0068e31cd878e07f3dffa4c6afba6242a753dac83b3799470149d2e816c1a2a7"

    # Fix build with newer boost by changing boost::filesystem to std::filesystem
    # Backport of https://github.com/apngasm/apngasm/commit/de1c87cd7696384be3235eb07766766891474e09
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9f447e672e2a167926aba3a733123ad244be88f5814dbf86dff970394537abf4"
    sha256 cellar: :any,                 big_sur:       "6cbad5185766695cdf400d99aae063ea9d6c97e39b4ef1e56d5b74c98abcb359"
    sha256 cellar: :any,                 catalina:      "31d5d3176ba5d537d34ca05e9a10a3d61b60a625545fe03250c6329a0463d341"
    sha256 cellar: :any,                 mojave:        "7ce45f6142f41d016eddded9324a7a65dd9921d2156f2d4fe2cadc3e1f991e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d481ab909b2f38ac93775ff33eb1470ee31c39bf7981cb0ab420b6f4edbcbed4"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libpng"
  depends_on "lzlib"
  depends_on macos: :catalina # Requires C++17 filesystem

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  def install
    inreplace "cli/CMakeLists.txt", "${CMAKE_INSTALL_PREFIX}/man/man1",
                                    "${CMAKE_INSTALL_PREFIX}/share/man/man1"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    (pkgshare/"test").install "test/samples"
  end

  test do
    system bin/"apngasm", "#{pkgshare}/test/samples/clock*.png"
  end
end

__END__
diff --git a/cli/CMakeLists.txt b/cli/CMakeLists.txt
index 636be8a..9096f32 100644
--- a/cli/CMakeLists.txt
+++ b/cli/CMakeLists.txt
@@ -19,7 +19,10 @@ ADD_EXECUTABLE(apngasm-cli
     ${PROJECT_SOURCE_DIR}/src/cli.cpp
 )
 SET_TARGET_PROPERTIES(apngasm-cli
-	PROPERTIES OUTPUT_NAME apngasm)
+	PROPERTIES
+  OUTPUT_NAME apngasm
+  CXX_STANDARD 17
+)
 
 # Link libraries
 LINK_DIRECTORIES(${PROJECT_BINARY_DIR}/../lib)
@@ -36,7 +39,7 @@ TARGET_LINK_LIBRARIES(apngasm-cli ${ZLIB_LIBRARIES})
 IF(APPLE OR WIN32)
   SET(Boost_USE_STATIC_LIBS ON)
 ENDIF(APPLE OR WIN32)
-FIND_PACKAGE(Boost REQUIRED COMPONENTS program_options regex filesystem system) 
+FIND_PACKAGE(Boost REQUIRED COMPONENTS program_options regex system) 
 INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIRS}) 
 TARGET_LINK_LIBRARIES(apngasm-cli ${Boost_LIBRARIES})
 
diff --git a/cli/src/cli.cpp b/cli/src/cli.cpp
index 88951f1..3a93679 100644
--- a/cli/src/cli.cpp
+++ b/cli/src/cli.cpp
@@ -1,14 +1,14 @@
 #include "cli.h"
 #include "apngasm-cli-version.h"
+#include <filesystem>
 #include <iostream>
 #include <boost/algorithm/string.hpp>
 #include <boost/regex.hpp>
-#include <boost/filesystem.hpp>
 #include "listener/apngasmlistener.h"
 
 
 namespace {
-  const char separator = boost::filesystem::path::preferred_separator;
+  const char separator = std::filesystem::path::preferred_separator;
 
   bool isNumber(const std::string s)
   {
@@ -121,12 +121,12 @@ namespace {
 	  // Return true if create succeeded.
 	  bool createParentDirs(const std::string& filePath) const
 	  {
-		  boost::filesystem::path path = filePath;
-		  boost::filesystem::path parent = path.parent_path();
+		  std::filesystem::path path = filePath;
+		  std::filesystem::path parent = path.parent_path();
 		  if(parent == "") {
 			  return true;
 		  }
-		  return boost::filesystem::create_directories(parent);
+		  return std::filesystem::create_directories(parent);
 	  }
   };	// class CustomAPNGAsmListener
 
@@ -264,7 +264,7 @@ namespace apngasm_cli {
 		// Output png image files.
 		std::string outdir;
 		if(!options.outputFile(outdir)) {
-			boost::filesystem::path path = src;
+			std::filesystem::path path = src;
 			outdir = path.replace_extension("").string();
 		}
 		if( !assembler.savePNGs(outdir) )
@@ -274,7 +274,7 @@ namespace apngasm_cli {
 		std::string outSpecFile;
 		if( options.outputJSONFile(outSpecFile) )
 		{
-			boost::filesystem::path path = outSpecFile;
+			std::filesystem::path path = outSpecFile;
 			if(path.is_relative())
 				outSpecFile = outdir + separator + outSpecFile;
 
@@ -284,7 +284,7 @@ namespace apngasm_cli {
 		// Output XML spec files.
 		if( options.outputXMLFile(outSpecFile) )
 		{
-			boost::filesystem::path path = outSpecFile;
+			std::filesystem::path path = outSpecFile;
 			if(path.is_relative())
 				outSpecFile = outdir + separator + outSpecFile;
 
diff --git a/lib/CMakeLists.txt b/lib/CMakeLists.txt
index 86447e3..41a5a7d 100644
--- a/lib/CMakeLists.txt
+++ b/lib/CMakeLists.txt
@@ -25,7 +25,10 @@ ADD_LIBRARY(apngasm SHARED
   ${PROJECT_SOURCE_DIR}/src/spec/priv/specwriterimpl.cpp
   ${PROJECT_SOURCE_DIR}/src/listener/apngasmlistener.cpp
 )
-
+SET_TARGET_PROPERTIES(apngasm
+	PROPERTIES
+  CXX_STANDARD 17
+)
 
 # Link libraries
 FIND_PACKAGE(PNG REQUIRED)
@@ -39,7 +42,7 @@ TARGET_LINK_LIBRARIES(apngasm ${ZLIB_LIBRARIES})
 IF(APPLE OR WIN32)
   SET(Boost_USE_STATIC_LIBS ON)
 ENDIF(APPLE OR WIN32)
-FIND_PACKAGE(Boost REQUIRED COMPONENTS program_options regex filesystem system) 
+FIND_PACKAGE(Boost REQUIRED COMPONENTS program_options regex system) 
 INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIRS})
 TARGET_LINK_LIBRARIES(apngasm ${Boost_LIBRARIES})
 
diff --git a/lib/src/apngasm.cpp b/lib/src/apngasm.cpp
index 07434bd..e6d1b1c 100644
--- a/lib/src/apngasm.cpp
+++ b/lib/src/apngasm.cpp
@@ -1,9 +1,9 @@
 #include "apngasm.h"
 #include <cstdlib>
+#include <filesystem>
 #include <png.h>
 #include <zlib.h>
 #include <boost/algorithm/string/predicate.hpp>
-#include <boost/filesystem/operations.hpp>
 #include <boost/regex.hpp>
 #include <boost/range/algorithm.hpp>
 #ifdef APNG_SPECS_SUPPORTED
@@ -56,13 +56,13 @@ namespace apngasm {
     {
       static std::vector<std::string> files;
 
-      boost::filesystem::path nativePath(filepath);
+      std::filesystem::path nativePath(filepath);
       nativePath.make_preferred();
 
       // filepath is current directory.
       if( !nativePath.has_parent_path() )
       {
-        const std::string currentDirPath = "." + std::string(1, boost::filesystem::path::preferred_separator);
+        const std::string currentDirPath = "." + std::string(1, std::filesystem::path::preferred_separator);
         nativePath = currentDirPath + nativePath.string();
       }
 
@@ -76,14 +76,14 @@ namespace apngasm {
         if (!boost::algorithm::iends_with(nativePath.string(), ".png"))
           nativePath = nativePath.string() + ".png";
 
-        if (boost::filesystem::exists(nativePath))
+        if (std::filesystem::exists(nativePath))
           files.push_back(nativePath.string());
       }
 
       // File path has wildcard.
       else
       {
-        const boost::filesystem::path &parentPath = nativePath.parent_path();
+        const std::filesystem::path &parentPath = nativePath.parent_path();
 
         // Convert filepath.
         static const boost::regex escape("[\\^\\.\\$\\|\\(\\)\\[\\]\\+\\?\\\\]");
@@ -93,16 +93,16 @@ namespace apngasm {
         nativePath = boost::regex_replace(nativePath.string(), wildcard, ".*");
 
         // Skip if directory is not found.
-        if (!boost::filesystem::exists(parentPath))
+        if (!std::filesystem::exists(parentPath))
           return files;
 
         // Search files.
         const boost::regex filter(nativePath.string());
-        const boost::filesystem::directory_iterator itEnd;
-        for (boost::filesystem::directory_iterator itCur(parentPath); itCur != itEnd; ++itCur)
+        const std::filesystem::directory_iterator itEnd;
+        for (std::filesystem::directory_iterator itCur(parentPath); itCur != itEnd; ++itCur)
         {
           // Skip if not a file.
-          if (!boost::filesystem::is_regular_file(itCur->status()))
+          if (!std::filesystem::is_regular_file(itCur->status()))
             continue;
 
           // Skip if no match.
diff --git a/lib/src/listener/apngasmlistener.cpp b/lib/src/listener/apngasmlistener.cpp
index 060dc4e..e46680a 100644
--- a/lib/src/listener/apngasmlistener.cpp
+++ b/lib/src/listener/apngasmlistener.cpp
@@ -1,6 +1,6 @@
 #include "apngasmlistener.h"
+#include <filesystem>
 #include <sstream>
-#include <boost/filesystem/operations.hpp>
 
 namespace apngasm {
   namespace listener {
@@ -48,7 +48,7 @@ namespace apngasm {
     // Return output path.
     const std::string APNGAsmListener::onCreatePngPath(const std::string& outputDir, int index) const
     {
-      const char separator = boost::filesystem::path::preferred_separator;
+      const char separator = std::filesystem::path::preferred_separator;
       const std::string separatorStr = (outputDir.empty() || *outputDir.rbegin() == separator) ? "" : std::string(1, separator);
       std::ostringstream result;
       result  << outputDir
diff --git a/lib/src/spec/priv/specreaderimpl.cpp b/lib/src/spec/priv/specreaderimpl.cpp
index 5e14b3d..ab67dbb 100644
--- a/lib/src/spec/priv/specreaderimpl.cpp
+++ b/lib/src/spec/priv/specreaderimpl.cpp
@@ -1,10 +1,10 @@
 #include "specreaderimpl.h"
 #include "../../apngframe.h"  // DEFAULT_FRAME_NUMERATOR, DEFAULT_FRAME_DENOMINATOR
+#include <filesystem>
 #include <boost/property_tree/json_parser.hpp>
 #include <boost/property_tree/xml_parser.hpp>
 #include <boost/lexical_cast.hpp>
 #include <boost/foreach.hpp>
-#include <boost/filesystem/operations.hpp>
 
 namespace apngasm {
   namespace spec {
@@ -104,10 +104,10 @@ namespace apngasm {
         boost::property_tree::read_json(filePath, root);
 
         // Set current directory.
-        const boost::filesystem::path oldPath = boost::filesystem::current_path();
-        const boost::filesystem::path currentPath = boost::filesystem::path(filePath);
+        const std::filesystem::path oldPath = std::filesystem::current_path();
+        const std::filesystem::path currentPath = std::filesystem::path(filePath);
         if(currentPath.has_parent_path())
-          boost::filesystem::current_path(currentPath.parent_path());
+          std::filesystem::current_path(currentPath.parent_path());
 
         // Read fields.
         // name
@@ -181,7 +181,7 @@ namespace apngasm {
             }
 
             // Add frame informations.
-            const FrameInfo frameInfo = { boost::filesystem::absolute(file).string(), delay };
+            const FrameInfo frameInfo = { std::filesystem::absolute(file).string(), delay };
             _frameInfos.push_back(frameInfo);
 
             ++delayIndex;
@@ -189,7 +189,7 @@ namespace apngasm {
         }
 
         // Reset current directory.
-        boost::filesystem::current_path(oldPath);
+        std::filesystem::current_path(oldPath);
 
         return true;
       }
@@ -203,10 +203,10 @@ namespace apngasm {
         boost::property_tree::read_xml(filePath, root);
 
         // Set current directory.
-        const boost::filesystem::path oldPath = boost::filesystem::current_path();
-        const boost::filesystem::path currentPath = boost::filesystem::path(filePath);
+        const std::filesystem::path oldPath = std::filesystem::current_path();
+        const std::filesystem::path currentPath = std::filesystem::path(filePath);
         if(currentPath.has_parent_path())
-          boost::filesystem::current_path(currentPath.parent_path());
+          std::filesystem::current_path(currentPath.parent_path());
 
         // Read fields.
         // name
@@ -267,13 +267,13 @@ namespace apngasm {
             }
 
             // Add frame informations.
-            const FrameInfo frameInfo = { boost::filesystem::absolute(file).string(), delay };
+            const FrameInfo frameInfo = { std::filesystem::absolute(file).string(), delay };
             _frameInfos.push_back(frameInfo);
           }
         }
 
         // Reset current directory.
-        boost::filesystem::current_path(oldPath);
+        std::filesystem::current_path(oldPath);
 
         return true;
       }
diff --git a/lib/src/spec/specwriter.cpp b/lib/src/spec/specwriter.cpp
index 474f857..1642e08 100644
--- a/lib/src/spec/specwriter.cpp
+++ b/lib/src/spec/specwriter.cpp
@@ -1,27 +1,27 @@
 #include "specwriter.h"
 #include "priv/specwriterimpl.h"
 #include "../apngasm.h"
-#include <boost/filesystem/operations.hpp>
+#include <filesystem>
 
 namespace apngasm {
   namespace spec {
 
     namespace {
-      const char separator = boost::filesystem::path::preferred_separator;
+      const char separator = std::filesystem::path::preferred_separator;
 
-      const boost::filesystem::path createAbsolutePath(const std::string& path)
+      const std::filesystem::path createAbsolutePath(const std::string& path)
       {
-        const boost::filesystem::path oldPath = boost::filesystem::current_path();
-        boost::filesystem::path result = path;
-        boost::filesystem::current_path(result.parent_path());
-        result = boost::filesystem::current_path();
-        boost::filesystem::current_path(oldPath);
+        const std::filesystem::path oldPath = std::filesystem::current_path();
+        std::filesystem::path result = path;
+        std::filesystem::current_path(result.parent_path());
+        result = std::filesystem::current_path();
+        std::filesystem::current_path(oldPath);
         return result;
       }
       const std::string createRelativeDir(const std::string& from, const std::string& to)
       {
-        boost::filesystem::path fromPath = createAbsolutePath(from);
-        boost::filesystem::path toPath = createAbsolutePath(to);
+        std::filesystem::path fromPath = createAbsolutePath(from);
+        std::filesystem::path toPath = createAbsolutePath(to);
         const std::string separatorStr = std::string(1, separator);
 
         // Convert path to native.
diff --git a/test/CMakeLists.txt b/test/CMakeLists.txt
index 26fa33b..7807950 100644
--- a/test/CMakeLists.txt
+++ b/test/CMakeLists.txt
@@ -12,7 +12,10 @@ ADD_EXECUTABLE(apngasm-test
 )
 
 SET_TARGET_PROPERTIES(apngasm-test
-	PROPERTIES OUTPUT_NAME apngtest)
+	PROPERTIES
+	OUTPUT_NAME apngtest
+	CXX_STANDARD 17
+)
 
 LINK_DIRECTORIES(${PROJECT_BINARY_DIR}/../lib)
 INCLUDE_DIRECTORIES(
