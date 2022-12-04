class Ns3 < Formula
  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.37/ns-3-dev-ns-3.37.tar.bz2"
  sha256 "d72defeeddbba14397cd4403565992d98cd7b7d9c680c22fee56022706878720"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "41366faa65418e3a2bc4edcf8205ef8c255584dc41dd3e474ffb043810e3348c"
    sha256 cellar: :any,                 arm64_monterey: "3d489bfd184d65cc26ccb3b09ca005e6ddf41ce6ca15abce25c59d9a9ae95ca5"
    sha256 cellar: :any,                 arm64_big_sur:  "68aac9355130e2cc027c95b9255d150c10c817d4f9aefa94708543ecc0b20a64"
    sha256 cellar: :any,                 ventura:        "daaa6ae7d3053f5370aa7955dc1e7548dd1925706e4da43d89e4511936de2729"
    sha256 cellar: :any,                 monterey:       "3cae5abbf94429cdcef4d13f8b51ef34e16204761c29e9551332b5859854f740"
    sha256 cellar: :any,                 big_sur:        "5a88644764053c9a4852adaa074b0bcf503b1616129821afa689e7fadd5d2bb3"
    sha256 cellar: :any,                 catalina:       "5167dc9662ae8e1998bcd132c9af32b235dd848321cd357f3532d072427e763c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46bb6dbfa98be9574f3ca0e2f69f1d0aa0749be73a868f33f6da5733259e3e9"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on xcode: [:build, "11"]

  depends_on "gsl"
  depends_on "open-mpi"
  depends_on "python@3.11"

  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  # Clears the Python3_LIBRARIES variable. Removing `PRIVATE ${Python3_LIBRARIES}`
  # in ns3-module-macros is not sufficient as it doesn't apply to visualizer.so.
  # Try to remove in next release
  on_macos do
    patch :DATA
  end

  # Needs GCC 8 or above
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"

  def python3
    "python3.11"
  end

  def install
    # Fix binding's rpath
    linker_flags = ["-Wl,-rpath,#{loader_path}"]
    linker_flags << "-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
                    "-DNS3_GTK3=OFF",
                    "-DNS3_PYTHON_BINDINGS=ON",
                    "-DNS3_BINDINGS_INSTALL_DIR=#{prefix/Language::Python.site_packages(python3)}",
                    "-DNS3_MPI=ON",
                    "-DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags.join(" ")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/tutorial/first.cc", "examples/tutorial/first.py"
  end

  test do
    system ENV.cxx, pkgshare/"first.cc", "-I#{include}", "-L#{lib}",
           "-lns#{version}-core", "-lns#{version}-network", "-lns#{version}-internet",
           "-lns#{version}-point-to-point", "-lns#{version}-applications",
           "-std=c++17", "-o", "test"
    system "./test"

    system Formula["python@3.11"].opt_bin/"python3.11", pkgshare/"first.py"
  end
end

__END__
diff --git a/build-support/macros-and-definitions.cmake b/build-support/macros-and-definitions.cmake
index 304ccdde7..64ae322c5 100644
--- a/build-support/macros-and-definitions.cmake
+++ b/build-support/macros-and-definitions.cmake
@@ -723,7 +723,8 @@ macro(process_options)
   if(${Python3_Interpreter_FOUND})
     if(${Python3_Development_FOUND})
       set(Python3_FOUND TRUE)
-      if(APPLE)
+      set(Python3_LIBRARIES "")
+      if(FALSE)
         # Apple is very weird and there could be a lot of conflicting python
         # versions which can generate conflicting rpaths preventing the python
         # bindings from working
