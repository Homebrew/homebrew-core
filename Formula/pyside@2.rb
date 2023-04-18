class PysideAT2 < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.9-src/pyside-setup-opensource-src-5.15.9.tar.xz"
  sha256 "2ea5917652036a9007d66ba4dc0aa75f381a3a25ccf0fa70fa2d9e9c8c9dacae"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside2/"
    regex(%r{href=.*?PySide2[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "e0ae9f352fd9ec27e50e92209de5d24b4017c5e499d453d2fe968676f38d1e6f"
    sha256 cellar: :any, arm64_monterey: "df42f30ff0f073c11e81cdb08746a31b663a9f31ab1b3109f9fb5aadb8ae4003"
    sha256 cellar: :any, arm64_big_sur:  "afbe9f3d564b2e315085fdc0df2c1687e91e9fd7946be9c2513dd064a688a4e4"
    sha256 cellar: :any, ventura:        "68560b96de5e903a2dbdef79493d553dd26152b8c641a8d2fbe023b2d3ab931e"
    sha256 cellar: :any, monterey:       "a00024acc6eb301afae573139743b97ba9f391c8d2845eb220e76198988f291a"
    sha256 cellar: :any, big_sur:        "efeb7dcc1dba741a62a93558eb59461e2ddd73ab27a8c44d03bfe9c6e081eeaa"
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

  # Fix build using ArchLinux patch. The corresponding code in shiboken6 was modified
  # in a later commit. Can remove when upstream decides to backport a fix to shiboken2.
  # Ref: https://codereview.qt-project.org/c/pyside/pyside-setup/+/365002
  patch do
    url "https://raw.githubusercontent.com/archlinux/svntogit-packages/7a6b2d1862ed9cbdd7ebcbcc9d6635e67cd1feab/trunk/fix-build.patch"
    sha256 "4f8815840b5df2e1e3b9f201a3402126821b0d9702920cefdc18050639143ad1"
  end

  # Fix error: use of undeclared identifier 'NPY_ARRAY_UPDATEIFCOPY'.
  # Remove in v5.15.10 as PYSIDE-2035 mentions fix was backported there.
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
