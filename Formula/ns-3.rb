class Ns3 < Formula
  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.36.1/ns-3-dev-ns-3.36.1.tar.bz2"
  sha256 "8826dbb35290412df9885d8a936ab0c3fe380dec4dd48c57889148c0a2c1a856"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dd8388b7afa86166b4390d2765b44bc2fafdff36994692077af65f9800e47a73"
    sha256 cellar: :any,                 arm64_big_sur:  "6d4bb953d0bdf69a52b98a5518c3e6bd838f8cc516133ae638855523548b7540"
    sha256 cellar: :any,                 monterey:       "5fe92587f3fdbcc942bd0c771f8e2b5153afb4ed96100da86112dac6454a511c"
    sha256 cellar: :any,                 big_sur:        "8037a6167d7b50b2e2349ce6d7fb25049aa65b36123d99128be1c2382ca3530c"
    sha256 cellar: :any,                 catalina:       "8ebabc28901eaf3ab45ddbb20e2da25399f871edc88844125c672656af010627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce00bfe0a855a282a1b8498623fca9c6bf5aca22cb755dc99c360583207b9e0"
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
