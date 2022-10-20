class Ns3 < Formula
  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.36.1/ns-3-dev-ns-3.36.1.tar.bz2"
  sha256 "8826dbb35290412df9885d8a936ab0c3fe380dec4dd48c57889148c0a2c1a856"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "3d489bfd184d65cc26ccb3b09ca005e6ddf41ce6ca15abce25c59d9a9ae95ca5"
    sha256 cellar: :any,                 arm64_big_sur:  "68aac9355130e2cc027c95b9255d150c10c817d4f9aefa94708543ecc0b20a64"
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
  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  # Clears the Python3_LIBRARIES variable. Removing `PRIVATE ${Python3_LIBRARIES}`
  # in ns3-module-macros is not sufficient as it doesn't apply to visualizer.so.
  # Should be no longer needed when 3.37 rolls out.
  on_macos do
    patch :DATA
  end

  # Needs GCC 8 or above
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"

  resource "pybindgen" do
    url "https://files.pythonhosted.org/packages/e0/8e/de441f26282eb869ac987c9a291af7e3773d93ffdb8e4add664b392ea439/PyBindGen-0.22.1.tar.gz"
    sha256 "8c7f22391a49a84518f5a2ad06e3a5b1e839d10e34da7631519c8a28fcba3764"
  end

  def install
    resource("pybindgen").stage buildpath.parent/"pybindgen"
    ENV.append "PYTHONPATH", buildpath.parent/"pybindgen"

    # Fix binding's rpath
    linker_flags = ["-Wl,-rpath,#{loader_path}"]
    linker_flags << "-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
                    "-DNS3_GTK3=OFF",
                    "-DNS3_PYTHON_BINDINGS=ON",
                    "-DNS3_MPI=ON",
                    "-DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags.join(" ")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Starting 3.36, bindings are no longer installed
    # https://gitlab.com/nsnam/ns-3-dev/-/merge_requests/1060
    site_packages = Language::Python.site_packages("python3.10")
    (prefix/site_packages).install (buildpath/"build/bindings/python").children

    pkgshare.install "examples/tutorial/first.cc", "examples/tutorial/first.py"
  end

  test do
    system ENV.cxx, pkgshare/"first.cc", "-I#{include}", "-L#{lib}",
           "-lns#{version}-core", "-lns#{version}-network", "-lns#{version}-internet",
           "-lns#{version}-point-to-point", "-lns#{version}-applications",
           "-std=c++17", "-o", "test"
    system "./test"

    system Formula["python@3.10"].opt_bin/"python3.10", pkgshare/"first.py"
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
