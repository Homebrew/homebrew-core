class Ns3 < Formula
  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.36.1/ns-3-dev-ns-3.36.1.tar.bz2"
  sha256 "8826dbb35290412df9885d8a936ab0c3fe380dec4dd48c57889148c0a2c1a856"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_monterey: "4f3d2a4df386be25087fa43898cfd7e5dc3f839ae8654720b5a6ae1453c33ba8"
    sha256 cellar: :any, arm64_big_sur:  "e08ff31e390431d96faa2676104a227d19028837428c2d2d5730fa9e88e436ea"
    sha256 cellar: :any, monterey:       "39baddc92860b4e43331b979ea23d53b05d6a1f60f83bbac23b8a07e7fa621ea"
    sha256 cellar: :any, big_sur:        "d0f2c1d3bd2b1b6eba5cd2d86d7a08ff83ecc0cb3116a8436c49eaa429161bcd"
    sha256 cellar: :any, catalina:       "fe65d59b1528b61d2e6acda4c634e2adf1721113caa0a6433127fffe864134d1"
    sha256               x86_64_linux:   "c9c36b988db945172517f6563f9b33e93093c259cab21cf07fac8e8faffad99e"
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

  on_linux do
    depends_on "gcc"
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
    linker_flags = if OS.mac?
      "-Wl,-undefined,dynamic_lookup,-rpath,@loader_path"
    else
      "-Wl,-rpath,$ORIGIN"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DNS3_GTK3=OFF",
                    "-DNS3_PYTHON_BINDINGS=ON",
                    "-DNS3_MPI=ON",
                    "-DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags}",
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
