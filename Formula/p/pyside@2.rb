class PysideAT2 < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.17-src/pyside-setup-opensource-src-5.15.17.tar.xz"
  sha256 "84a4b328f6a60235b8717ad522b88a7b600059260c57a2189ed005109f24c527"
  # NOTE: We omit some licenses:
  # 1. LICENSE.COMMERCIAL is removed from "OR" options as non-free
  # 2. GFDL-1.3-only is only used by not installed docs, e.g. sources/{pyside2,shiboken2}/doc
  # 3. BSD-3-Clause is only used by not installed examples
  license all_of: [
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
  ]

  bottle do
    sha256                               arm64_sequoia: "49044784ca72cc2c0b6a2cbf1c531854d8cf6293b13fa60c8265835e52403d2a"
    sha256                               arm64_sonoma:  "20ba3bca0f3bfea74630e7caa6fcd82f5da40e4970f5073fe5091a6c08e48d8b"
    sha256                               arm64_ventura: "62c1472775311f41aceb05954caa84520e71f3905e2c9582336015dc800cabef"
    sha256 cellar: :any,                 sonoma:        "b910886b9a7b04f34af7c895361faa4821b1681f12555d8a72c2fbf22126cf9c"
    sha256 cellar: :any,                 ventura:       "871b29070a8cee9730509ca9c27339147e372a601add0ea0ecc5493e3f42ba67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e633d78c4c6207fde6216d4b17df91c77f06489c32826bdcf96921156cad9243"
  end

  keg_only :versioned_formula

  # Requires various patches and cannot be built with `FORCE_LIMITED_API` with Python 3.12.
  # `qt@5` is also officially EOL on 2025-05-25.
  disable! date: "2025-05-26", because: :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "llvm"
  depends_on "python@3.10"
  depends_on "qt@5"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "libxcb"
    depends_on "mesa"
  end

  # Don't copy qt@5 tools.
  patch do
    url "https://src.fedoraproject.org/rpms/python-pyside2/raw/009100c67a63972e4c5252576af1894fec2e8855/f/pyside2-tools-obsolete.patch"
    sha256 "ede69549176b7b083f2825f328ca68bd99ebf8f42d245908abd320093bac60c9"
  end

  # Apply Debian patches to support newer Clang
  # Upstream issue ref: https://bugreports.qt.io/browse/PYSIDE-2268
  patch do
    url "https://deb.debian.org/debian/pool/main/p/pyside2/pyside2_5.15.16-3.1.debian.tar.xz"
    sha256 "523d191e45b1a9720e8eb8ea66fd930f49ffad54df1295ca09efea8838257aa6"
    apply "patches/shiboken2-clang-Fix-clashes-between-type-name-and-enumera.patch",
          "patches/shiboken2-clang-Fix-and-simplify-resolveType-helper.patch",
          "patches/shiboken2-clang-Remove-typedef-expansion.patch",
          "patches/shiboken2-clang-Fix-build-with-clang-16.patch",
          "patches/shiboken2-clang-Record-scope-resolution-of-arguments-func.patch",
          "patches/shiboken2-clang-Suppress-class-scope-look-up-for-paramete.patch",
          "patches/shiboken2-clang-Write-scope-resolution-for-all-parameters.patch"
  end
  patch do
    url "https://salsa.debian.org/qt-kde-team/qt/pyside2/-/raw/46111b30f4b4f01bed7b55dc7cc9a800809b2cb4/debian/patches/Modify-sendCommand-signatures.patch"
    sha256 "2f39461136a718a9f75bd94c1e71fc358764af25f68c650fd503c777e32ff302"
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
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DFORCE_LIMITED_API=#{OS.mac? ? "yes" : "no"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python = which(python3)
    ENV.append_path "PYTHONPATH", prefix/Language::Python.site_packages(python)
    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"

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

    (testpath/"test.cpp").write <<~CPP
      #include <shiboken.h>
      int main()
      {
        Py_Initialize();
        Shiboken::AutoDecRef module(Shiboken::Module::import("shiboken2"));
        assert(!module.isNull());
        return 0;
      }
    CPP
    rpaths = []
    rpaths += ["-Wl,-rpath,#{lib}", "-Wl,-rpath,#{Formula["python@3.10"].opt_lib}"] unless OS.mac?
    shiboken_flags = shell_output("pkgconf --cflags --libs shiboken2").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", *shiboken_flags, *rpaths, *pyincludes, *pylib, "-o", "test"
    system "./test"
  end
end
