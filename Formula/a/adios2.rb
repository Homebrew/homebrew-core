class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  license "Apache-2.0"
  head "https://github.com/ornladios/ADIOS2.git", branch: "master"

  stable do
    url "https://github.com/ornladios/ADIOS2/archive/refs/tags/v2.10.0.tar.gz"
    sha256 "e5984de488bda546553dd2f46f047e539333891e63b9fe73944782ba6c2d95e4"

    # fix pugixml target name
    # upstream patch ref, https://github.com/ornladios/ADIOS2/pull/4135
    # https://github.com/ornladios/ADIOS2/pull/4142
    patch :DATA
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f27bc3122be07a98fd8db78211d426cc0288623dff91e7427840266936855a1e"
    sha256 arm64_ventura:  "de760c48271b31dc9310360fdc9b381d916625a5a8ae49d114dcc22e6dc444a5"
    sha256 arm64_monterey: "988b4a7ca6198fcebd0a430b84918e6ed58bbceb71983b9e0c14024637f41a80"
    sha256 sonoma:         "dfa5e5f519e3266512b5963937070607e3362281e0219d028f8b43f3d29b0528"
    sha256 ventura:        "ecc5229d30b5d6c61d21834dc280e48ff85c9f3c954cbea3009025f945dd6640"
    sha256 monterey:       "59caa71985070eb7d28f0fd096782299e88ab64eed87f0200f00cf30c8e045c2"
    sha256 x86_64_linux:   "97f031412ebf7c38631b2b30087675beed1fd1f28c2a87f4ad25654175ba879c"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "c-blosc"
  depends_on "gcc" # for gfortran
  depends_on "libfabric"
  depends_on "libpng"
  depends_on "libsodium"
  depends_on "mpi4py"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "pugixml"
  depends_on "pybind11"
  depends_on "python@3.12"
  depends_on "yaml-cpp"
  depends_on "zeromq"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version == 1400
  end

  # clang: error: unable to execute command: Segmentation fault: 11
  # clang: error: clang frontend command failed due to signal (use -v to see invocation)
  # Apple clang version 14.0.0 (clang-1400.0.29.202)
  fails_with :clang if DevelopmentTools.clang_build_version == 1400

  def python3
    "python3.12"
  end

  def install
    ENV.llvm_clang if DevelopmentTools.clang_build_version == 1400

    # fix `include/adios2/common/ADIOSConfig.h` file audit failure
    inreplace "source/adios2/common/ADIOSConfig.h.in" do |s|
      s.gsub! ": @CMAKE_C_COMPILER@", ": #{ENV.cc}"
      s.gsub! ": @CMAKE_CXX_COMPILER@", ": #{ENV.cxx}"
    end

    args = %W[
      -DADIOS2_USE_Blosc=ON
      -DADIOS2_USE_BZip2=ON
      -DADIOS2_USE_DataSpaces=OFF
      -DADIOS2_USE_Fortran=ON
      -DADIOS2_USE_HDF5=OFF
      -DADIOS2_USE_IME=OFF
      -DADIOS2_USE_MGARD=OFF
      -DADIOS2_USE_MPI=ON
      -DADIOS2_USE_PNG=ON
      -DADIOS2_USE_Python=ON
      -DADIOS2_USE_SZ=OFF
      -DADIOS2_USE_ZeroMQ=ON
      -DADIOS2_USE_ZFP=OFF
      -DCMAKE_DISABLE_FIND_PACKAGE_BISON=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_CrayDRC=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_FLEX=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_LibFFI=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_NVSTREAM=TRUE
      -DPython_EXECUTABLE=#{which(python3)}
      -DCMAKE_INSTALL_PYTHONDIR=#{prefix/Language::Python.site_packages(python3)}
      -DADIOS2_BUILD_TESTING=OFF
      -DADIOS2_BUILD_EXAMPLES=OFF
      -DADIOS2_USE_EXTERNAL_DEPENDENCIES=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"test").install "examples/hello/bpWriter/bpWriter.cpp"
    (pkgshare/"test").install "examples/hello/bpWriter/bpWriter.py"
  end

  test do
    adios2_config_flags = Utils.safe_popen_read(bin/"adios2-config", "--cxx").chomp.split
    system "mpic++", pkgshare/"test/bpWriter.cpp", *adios2_config_flags
    system "./a.out"
    assert_predicate testpath/"myVector_cpp.bp", :exist?

    system python3, "-c", "import adios2"
    system python3, pkgshare/"test/bpWriter.py"
    assert_predicate testpath/"bpWriter-py.bp", :exist?
  end
end

__END__
diff --git a/source/adios2/toolkit/remote/CMakeLists.txt b/source/adios2/toolkit/remote/CMakeLists.txt
index a739e1a..fdea6ec 100644
--- a/source/adios2/toolkit/remote/CMakeLists.txt
+++ b/source/adios2/toolkit/remote/CMakeLists.txt
@@ -6,15 +6,11 @@
 if (NOT ADIOS2_USE_PIP)
   add_executable(adios2_remote_server ./remote_server.cpp remote_common.cpp)

-  target_link_libraries(adios2_remote_server PUBLIC EVPath::EVPath adios2_core adios2sys
-    PRIVATE $<$<PLATFORM_ID:Windows>:shlwapi>)
+  target_link_libraries(adios2_remote_server
+                        PUBLIC EVPath::EVPath adios2_core adios2sys
+                        PRIVATE adios2::thirdparty::pugixml $<$<PLATFORM_ID:Windows>:shlwapi>)

-  get_property(pugixml_headers_path
-    TARGET pugixml
-    PROPERTY INTERFACE_INCLUDE_DIRECTORIES
-  )
-
-  target_include_directories(adios2_remote_server PRIVATE ${PROJECT_BINARY_DIR} ${pugixml_headers_path})
+  target_include_directories(adios2_remote_server PRIVATE ${PROJECT_BINARY_DIR})

   set_property(TARGET adios2_remote_server PROPERTY OUTPUT_NAME adios2_remote_server${ADIOS2_EXECUTABLE_SUFFIX})
   install(TARGETS adios2_remote_server EXPORT adios2
diff --git a/source/utils/CMakeLists.txt b/source/utils/CMakeLists.txt
index 30dd484..01f5f93 100644
--- a/source/utils/CMakeLists.txt
+++ b/source/utils/CMakeLists.txt
@@ -13,17 +13,11 @@ configure_file(
 add_executable(bpls ./bpls/bpls.cpp)
 target_link_libraries(bpls
                       PUBLIC adios2_core adios2sys
-                      PRIVATE $<$<PLATFORM_ID:Windows>:shlwapi>)
-
-get_property(pugixml_headers_path
-  TARGET pugixml
-  PROPERTY INTERFACE_INCLUDE_DIRECTORIES
-)
+                      PRIVATE adios2::thirdparty::pugixml $<$<PLATFORM_ID:Windows>:shlwapi>)

 target_include_directories(bpls PRIVATE
   ${PROJECT_BINARY_DIR}
   ${PROJECT_SOURCE_DIR}/bindings/C
-  ${pugixml_headers_path}
 )

 set_property(TARGET bpls PROPERTY OUTPUT_NAME bpls${ADIOS2_EXECUTABLE_SUFFIX})
