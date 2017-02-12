class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  head "https://github.com/HaxeFoundation/haxe.git", :branch => "development"

  stable do
    url "https://github.com/HaxeFoundation/haxe.git",
      :tag => "3.4.0",
      :revision => "54090a4ed730c3aa04fa5ed845cadc737c15cac8"
    # To workaround issue https://github.com/HaxeFoundation/neko/issues/130
    # It is a commit already applied to the upstream, modified to apply in extra/haxelib_src
    # https://github.com/HaxeFoundation/haxelib/commit/eff059a50da4200635f3a22c5fc992b3fbf80e79
    patch :DATA
  end

  bottle do
    cellar :any
    sha256 "7e98883ce8d4e985f90dc53fcff567593c071cfe563f52932d7390ad2c22185a" => :sierra
    sha256 "6887bea23db0e6ace873cc01330b956f9d24babb01cd0c8c2471f1be7138e0b4" => :el_capitan
    sha256 "ef9c72f4a2b47cfc412f86879ba6d30c369eef843cae9c1d0b1585ad1161311c" => :yosemite
  end

  depends_on "ocaml" => :build
  depends_on "camlp4" => :build
  depends_on "cmake" => :build
  depends_on "neko"
  depends_on "pcre"

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    args = ["OCAMLOPT=ocamlopt.opt"]
    args << "ADD_REVISION=1" if build.head?
    system "make", *args

    # Rebuild haxelib as a valid binary
    Dir.chdir("extra/haxelib_src") do
      system "cmake", "."
      system "make"
    end
    rm "haxelib"
    cp "extra/haxelib_src/haxelib", "haxelib"

    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}", "INSTALL_LIB_DIR=#{lib}/haxe"

    # Replace the absolute symlink by a relative one,
    # such that binary package created by homebrew will work in non-/usr/local locations.
    rm bin/"haxe"
    bin.install_symlink lib/"haxe/haxe"
  end

  def caveats; <<-EOS.undent
    Add the following line to your .bashrc or equivalent:
      export HAXE_STD_PATH="#{HOMEBREW_PREFIX}/lib/haxe/std"
    EOS
  end

  test do
    ENV["HAXE_STD_PATH"] = "#{HOMEBREW_PREFIX}/lib/haxe/std"
    system "#{bin}/haxe", "-v", "Std"
    system "#{bin}/haxelib", "version"
  end
end

__END__
From eff059a50da4200635f3a22c5fc992b3fbf80e79 Mon Sep 17 00:00:00 2001
From: Andy Li <andy@onthewings.net>
Date: Fri, 3 Feb 2017 17:38:35 +0800
Subject: [PATCH] Added a CMakeLists.txt that can produce valid binary using
 `nekotools boot -c ...`.

Re. https://github.com/HaxeFoundation/neko/issues/130
---
 CMakeLists.txt | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 create mode 100644 CMakeLists.txt

diff --git a/extra/haxelib_src/CMakeLists.txt b/extra/haxelib_src/CMakeLists.txt
new file mode 100644
index 0000000..bb66d90
--- /dev/null
+++ b/extra/haxelib_src/CMakeLists.txt
@@ -0,0 +1,55 @@
+cmake_minimum_required(VERSION 2.8.7)
+
+include(GNUInstallDirs)
+project(Haxelib C)
+
+# put output in ${CMAKE_BINARY_DIR}
+
+set(OUTPUT_DIR ${CMAKE_BINARY_DIR})
+set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIR})
+set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_DIR})
+set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_DIR})
+
+# avoid the extra "Debug", "Release" directories
+# http://stackoverflow.com/questions/7747857/in-cmake-how-do-i-work-around-the-debug-and-release-directories-visual-studio-2
+foreach( OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES} )
+ string( TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG )
+ set( CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${OUTPUT_DIR} )
+ set( CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${OUTPUT_DIR} )
+ set( CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${OUTPUT_DIR} )
+endforeach( OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES )
+
+# find Haxe and Neko
+
+find_program(HAXE_COMPILER haxe)
+
+find_path(NEKO_INCLUDE_DIRS neko.h)
+find_library(NEKO_LIBRARIES neko)
+find_program(NEKO neko)
+find_program(NEKOTOOLS nekotools)
+
+message(STATUS "HAXE_COMPILER: ${HAXE_COMPILER}")
+message(STATUS "NEKO_INCLUDE_DIRS: ${NEKO_INCLUDE_DIRS}")
+message(STATUS "NEKO_LIBRARIES: ${NEKO_LIBRARIES}")
+message(STATUS "NEKOTOOLS: ${NEKOTOOLS}")
+
+include_directories(${NEKO_INCLUDE_DIRS})
+
+add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/run.n
+    COMMAND ${HAXE_COMPILER} client.hxml
+    VERBATIM
+    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
+)
+
+add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/run.c
+    COMMAND ${NEKOTOOLS} boot -c run.n
+    VERBATIM
+    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
+    DEPENDS ${CMAKE_SOURCE_DIR}/run.n
+)
+
+add_executable(haxelib
+    ${CMAKE_SOURCE_DIR}/run.c
+)
+
+target_link_libraries(haxelib ${NEKO_LIBRARIES})
