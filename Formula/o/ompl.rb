class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/refs/tags/1.7.0.tar.gz"
  sha256 "e2e2700dfb0b4c2d86e216736754dd1b316bd6a46cc8818e1ffcbce4a388aca9"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(%r{href=.*?/ompl/ompl/archive/v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "041e10c377511ea45af40e962fa9ce470616dae2cde49c01333731dfe38f4b56"
    sha256 cellar: :any,                 arm64_sonoma:  "b821378e7302d00b6f8aadc22dd606392bda600b236ce744ab04a90617029477"
    sha256 cellar: :any,                 arm64_ventura: "44393bc2559ef2cb1064943fdd2858cd6086b78a04cc0f98dcf19ec53f01bcb1"
    sha256 cellar: :any,                 sonoma:        "7cba8c475175ae9ad1824cb05b8dacf2605092883cb99a0d8fea2f73c21d939f"
    sha256 cellar: :any,                 ventura:       "7aa7fdf5d6d5e83483ce4a3ae8c923f8c212cef486896bba4b3bbfecd125a5eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36d4e4c8ae8e76a01f710f8af160e47e2e995633b8e53c09e8c67509ed64e79c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0800e3f94cdbf5727e2f79e6a90fa1a80ac182519e4557d2245d63346d5cbf4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "flann"
  depends_on "ode"

  # Workaround for Boost 1.89.0 until upstream fix.
  # Issue ref: https://github.com/ompl/ompl/issues/1305
  patch :DATA

  def install
    args = %w[
      -DOMPL_REGISTRATION=OFF
      -DOMPL_BUILD_DEMOS=OFF
      -DOMPL_BUILD_TESTS=OFF
      -DOMPL_BUILD_PYBINDINGS=OFF
      -DOMPL_BUILD_PYTESTS=OFF
      -DCMAKE_DISABLE_FIND_PACKAGE_spot=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Triangle=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ompl/base/spaces/RealVectorBounds.h>
      #include <cassert>
      int main(int argc, char *argv[]) {
        ompl::base::RealVectorBounds bounds(3);
        bounds.setLow(0);
        bounds.setHigh(5);
        assert(bounds.getVolume() == 5 * 5 * 5);
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}/ompl-#{version.major_minor}", "-L#{lib}", "-lompl", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 5f980f45..88e0f8ca 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -47,7 +47,7 @@ set_package_properties(Boost PROPERTIES
     URL "https://www.boost.org"
     PURPOSE "Used throughout OMPL for data serialization, graphs, etc.")
 set(Boost_USE_MULTITHREADED ON)
-find_package(Boost 1.68 REQUIRED COMPONENTS serialization filesystem system program_options)
+find_package(Boost 1.68 REQUIRED COMPONENTS serialization filesystem program_options)
 
 # on macOS we need to check whether to use libc++ or libstdc++ with clang++
 if(CMAKE_CXX_COMPILER_ID MATCHES "^(Apple)?Clang$")
diff --git a/CMakeModules/OMPLUtils.cmake b/CMakeModules/OMPLUtils.cmake
index ddd6f9af..9a63df7d 100644
--- a/CMakeModules/OMPLUtils.cmake
+++ b/CMakeModules/OMPLUtils.cmake
@@ -5,7 +5,6 @@ macro(add_ompl_test test_name)
     Boost::program_options
     Boost::serialization
     Boost::filesystem
-    Boost::system
     Boost::unit_test_framework)
   add_test(NAME ${test_name} COMMAND $<TARGET_FILE:${test_name}>)
 endmacro(add_ompl_test)
diff --git a/demos/CMakeLists.txt b/demos/CMakeLists.txt
index 3def76bf..d0827a8c 100644
--- a/demos/CMakeLists.txt
+++ b/demos/CMakeLists.txt
@@ -12,7 +12,6 @@ if (OMPL_BUILD_DEMOS)
             ompl::ompl
             Eigen3::Eigen
             Boost::filesystem
-            Boost::system
             Boost::program_options)
     endmacro(add_ompl_demo)
 
diff --git a/omplConfig.cmake.in b/omplConfig.cmake.in
index f1d47855..fd7dea37 100644
--- a/omplConfig.cmake.in
+++ b/omplConfig.cmake.in
@@ -12,7 +12,7 @@ set_and_check(OMPL_INCLUDE_DIRS @PACKAGE_INCLUDE_INSTALL_DIR@)
 
 include ("${CMAKE_CURRENT_LIST_DIR}/omplExport.cmake" )
 include(CMakeFindDependencyMacro)
-set(_@PROJECT_NAME@_boost_components serialization filesystem system)
+set(_@PROJECT_NAME@_boost_components serialization filesystem)
 find_dependency(Boost REQUIRED COMPONENTS ${_@PROJECT_NAME@_boost_components})
 if(Boost_FOUND)
     foreach(_comp ${_@PROJECT_NAME@_boost_components})
@@ -83,7 +83,7 @@ else()
     endif()
     
     # Add dependent libraries
-    foreach(_lib @Boost_SERIALIZATION_LIBRARY@;@Boost_FILESYSTEM_LIBRARY@;@Boost_SYSTEM_LIBRARY@;@SPOT_LIBRARIES@)
+    foreach(_lib @Boost_SERIALIZATION_LIBRARY@;@Boost_FILESYSTEM_LIBRARY@;@SPOT_LIBRARIES@)
         if(_lib)
             list(APPEND OMPL_LIBRARIES "${_lib}")
         endif()
diff --git a/src/ompl/CMakeLists.txt b/src/ompl/CMakeLists.txt
index 463930ca..82911ef2 100644
--- a/src/ompl/CMakeLists.txt
+++ b/src/ompl/CMakeLists.txt
@@ -44,7 +44,6 @@ target_link_libraries(ompl
     PUBLIC
         Boost::filesystem
         Boost::serialization
-        Boost::system
         Eigen3::Eigen
         "$<$<BOOL:${Threads_FOUND}>:Threads::Threads>"
         "$<$<BOOL:${OMPL_HAVE_FLANN}>:flann::flann>"
