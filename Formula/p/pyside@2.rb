class PysideAT2 < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.10-src/pyside-setup-opensource-src-5.15.10.tar.xz"
  sha256 "2af691d3613a41f83a60439b46568fc2c696dbfae42f7cd7b07152d115ead33a"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside2/"
    regex(%r{href=.*?PySide2[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "28af314823f58cb216bb57e1c74d2fb22904f736cb026c1788713661fa58dac2"
    sha256 cellar: :any, arm64_monterey: "cb7496bdae5f86a816371365a7d365d148ac5df4adbba53e89bf211e6307fc70"
    sha256 cellar: :any, arm64_big_sur:  "4cfb6722551c4ee4f935c8f81f74fc594158ae01dcc8529e5ca374c27e0d3ca0"
    sha256 cellar: :any, ventura:        "43b8c564ba4bcae4efc92f5108c847c52fb91ca8bdee8d2c9090e8ac6c5ec8a7"
    sha256 cellar: :any, monterey:       "e49318662072baa98a393d468a14135f2c3367d22c24e44e9938f0ede9464014"
    sha256 cellar: :any, big_sur:        "b7ec686cddddf16f2be64ffc086df0af7ce3ddeb067181336e063623b78a1226"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm@15" # Upstream issue ref: https://bugreports.qt.io/browse/PYSIDE-2268
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

  # Fix error: use of undeclared identifier 'NPY_ARRAY_UPDATEIFCOPY'.
  # Remove when the patch available in the next release.
  # Ref: https://codereview.qt-project.org/c/pyside/pyside-setup/+/418321
  # Ref: https://bugreports.qt.io/browse/PYSIDE-2035
  patch :p3 do
    url "https://code.qt.io/cgit/pyside/pyside-setup.git/patch/sources/shiboken6/libshiboken/sbknumpyarrayconverter.cpp?id=1422cf4a7f277fb13fd209f24a90d6c02641497d"
    sha256 "2148af37249932be15ca417076baa9539d487b38a434ec901a67fa9ede724f52"
    directory "sources/shiboken2"
  end

  def python3
    "python3.10"
  end

  def install
    rpaths = if OS.mac?
      pyside2_module = prefix/Language::Python.site_packages(python3)/"PySide2"
      [rpath, rpath(source: pyside2_module)]
    else
      # Add missing include dirs on Linux.
      # upstream issue: https://bugreports.qt.io/browse/PYSIDE-1684
      extra_include_dirs = [Formula["mesa"].opt_include, Formula["libxcb"].opt_include]
      inreplace "sources/pyside2/cmake/Macros/PySideModules.cmake",
                "--include-paths=${shiboken_include_dirs}",
                "--include-paths=${shiboken_include_dirs}:#{extra_include_dirs.join(":")}"

      # Add rpath to qt@5 because it is keg-only.
      [lib, Formula["qt@5"].opt_lib]
    end

    # Avoid shim reference.
    inreplace "sources/shiboken2/ApiExtractor/CMakeLists.txt", "${CMAKE_CXX_COMPILER}", ENV.cxx

    ENV.append_path "CMAKE_PREFIX_PATH", Formula["qt@5"].opt_lib
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DFORCE_LIMITED_API=yes",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python = which(python3)
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
