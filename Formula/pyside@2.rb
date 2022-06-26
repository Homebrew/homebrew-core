class PysideAT2 < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.5-src/pyside-setup-opensource-src-5.15.5.tar.xz"
  sha256 "3920a4fb353300260c9bc46ff70f1fb975c5e7efa22e9d51222588928ce19b33"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9981b3c216053460da40f7e9e05410159ddde34eb1f98a8387cae76e89020d8a"
    sha256 cellar: :any,                 arm64_big_sur:  "ee5a173573f466856605fa20407f90d1865a09941d791f9562acc630792dcbf9"
    sha256 cellar: :any,                 monterey:       "b635a0bd7b231c92eb1523e05945c6eb9fa03433a6245d81626bd12ccf89c78f"
    sha256 cellar: :any,                 big_sur:        "945f792656265d19ed410ea57be8484190794f0b44cae51efd82261dd2bbf9c1"
    sha256 cellar: :any,                 catalina:       "0dffb5bc45842350e82847d56e06c95d8d9b5b85b5e00bd2dae626589207cade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de4b9c0b559acfe32afb5fe7f51cdd7ba50a5811dba69d235c12a21dd2d05ccf"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "python@3.10"
  depends_on "qt@5"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "libxcb"
    depends_on "mesa"
  end

  fails_with gcc: "5"

  # Don't copy qt@5 tools.
  patch do
    url "https://src.fedoraproject.org/rpms/python-pyside2/raw/009100c67a63972e4c5252576af1894fec2e8855/f/pyside2-tools-obsolete.patch"
    sha256 "ede69549176b7b083f2825f328ca68bd99ebf8f42d245908abd320093bac60c9"
  end

  def install
    # upstream issue: https://bugreports.qt.io/browse/PYSIDE-1684
    unless OS.mac?
      extra_include_dirs = [Formula["mesa"].opt_include, Formula["libxcb"].opt_include]

      inreplace "sources/pyside2/cmake/Macros/PySideModules.cmake",
                "--include-paths=${shiboken_include_dirs}",
                "--include-paths=${shiboken_include_dirs}:#{extra_include_dirs.join(":")}"
    end

    args = std_cmake_args + %W[
      -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      -DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_lib}
      -DPYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_bin}/python3
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DFORCE_LIMITED_API=yes
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python = Formula["python@3.10"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", prefix/Language::Python.site_packages(python)

    system python, "-c", "import PySide2"
    system python, "-c", "import shiboken2"

    modules = %w[
      Core
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      WebEngineWidgets
      Widgets
      Xml
    ]

    modules.each { |mod| system python, "-c", "import PySide2.Qt#{mod}" }

    pyincludes = shell_output("#{python}-config --includes").chomp.split
    pylib = shell_output("#{python}-config --ldflags --embed").chomp.split

    (testpath/"test.cpp").write <<~EOS
      #include <shiboken.h>
      int main()
      {
        Py_Initialize();
        Shiboken::AutoDecRef module(Shiboken::Module::import("shiboken2"));
        assert(!module.isNull());
        return 0;
      }
    EOS
    rpaths = []
    rpaths += ["-Wl,-rpath,#{lib}", "-Wl,-rpath,#{Formula["python@3.10"].opt_lib}"] unless OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp",
           "-I#{include}/shiboken2", "-L#{lib}", "-lshiboken2.abi3", *rpaths,
           *pyincludes, *pylib, "-o", "test"
    system "./test"
  end
end
