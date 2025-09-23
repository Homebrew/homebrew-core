class Pyside < Formula
  include Language::Python::Virtualenv

  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.9.2-src/pyside-setup-everywhere-src-6.9.2.tar.xz"
  mirror "https://cdimage.debian.org/mirror/qt.io/qtproject/official_releases/QtForPython/pyside6/PySide6-6.9.2-src/pyside-setup-everywhere-src-6.9.2.tar.xz"
  sha256 "9ec087465342bdc9dbe492a30e58fdbbc5448655deacf5982a0fe7123f59222d"
  # NOTE: We omit some licenses even though they are in SPDX-License-Identifier or LICENSES/ directory:
  # 1. LicenseRef-Qt-Commercial is removed from "OR" options as non-free
  # 2. GFDL-1.3-no-invariants-only is only used by not installed docs, e.g. sources/{pyside6,shiboken6}/doc
  # 3. BSD-3-Clause is only used by not installed examples, tutorials and build scripts
  # 4. Apache-2.0 is only used by not installed examples
  license all_of: [
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
  ]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "4fbd6096d099769606e834b4b32332f5ff12695dba2fc87d94f12225ae025a00"
    sha256 cellar: :any,                 arm64_ventura: "50569549e185afeafe5309d1071ba3c50392c8c720c44f72380346b7aa545c74"
    sha256 cellar: :any,                 sonoma:        "5263e135d9728e212f4375019ae2ad77a26829fd62470755405df24f23a635e2"
    sha256 cellar: :any,                 ventura:       "9a62fb3f10d551b455bae79bbc4d50ee5751cd873aa8f44f8448c17d263e90fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "102e2c7e32c6dd82c483f07d5406449ac91f74651898163312b71497971f0174"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on xcode: :build
  depends_on "pkgconf" => :test
  depends_on "llvm"
  depends_on "python@3.13"
  depends_on "qt"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "mesa"
  end

  # Fix .../sources/pyside6/qtexampleicons/module.c:4:10: fatal error: 'Python.h' file not found
  # Upstream issue: https://bugreports.qt.io/browse/PYSIDE-2491
  patch :DATA

  def python3
    "python3.13"
  end

  def install
    ENV.append_path "PYTHONPATH", buildpath/"build/sources"
    if OS.mac?
      # Avoid detection of unwanted formulae. Should be handled in brew instead
      ENV["CMAKE_PREFIX_PATH"] = ENV["CMAKE_PREFIX_PATH"].split(":")
                                                         .reject { |p| p == HOMEBREW_PREFIX.to_s }
                                                         .join(":")
    end

    extra_include_dirs = [Formula["qt"].opt_include]
    extra_include_dirs << Formula["mesa"].opt_include if OS.linux?

    # upstream issue: https://bugreports.qt.io/browse/PYSIDE-1684
    inreplace "sources/pyside6/cmake/Macros/PySideModules.cmake",
              "${shiboken_include_dirs}",
              "${shiboken_include_dirs}:#{extra_include_dirs.join(":")}"

    # Install python scripts into pkgshare rather than bin
    inreplace "sources/pyside-tools/CMakeLists.txt", "DESTINATION bin", "DESTINATION #{pkgshare}"

    # Avoid shim reference
    inreplace "sources/shiboken6/ApiExtractor/CMakeLists.txt", "${CMAKE_CXX_COMPILER}", ENV.cxx

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{lib}",
                    "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_lib}",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_TESTS=OFF",
                    "-DNO_QT_TOOLS=yes",
                    # Limited API (maybe combined with keg relocation) breaks the Linux bottle
                    "-DFORCE_LIMITED_API=#{OS.mac? ? "yes" : "no"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", "import PySide6"
    system python3, "-c", "import shiboken6"

    modules = %w[
      Core
      Gui
      Network
      Positioning
      Quick
      Svg
      Widgets
      Xml
    ]
    modules << "WebEngineCore" if OS.linux? || MacOS.version > :ventura
    modules.each { |mod| system python3, "-c", "import PySide6.Qt#{mod}" }

    pyincludes = shell_output("#{python3}-config --includes").chomp.split
    pylib = shell_output("#{python3}-config --ldflags --embed").chomp.split

    if OS.linux?
      pyver = Language::Python.major_minor_version python3
      pylib += %W[
        -Wl,-rpath,#{Formula["python@#{pyver}"].opt_lib}
        -Wl,-rpath,#{lib}
      ]
    end

    (testpath/"test.cpp").write <<~CPP
      #include <shiboken.h>
      int main()
      {
        Py_Initialize();
        Shiboken::AutoDecRef module(Shiboken::Module::import("shiboken6"));
        assert(!module.isNull());
        return 0;
      }
    CPP
    shiboken_flags = shell_output("pkgconf --cflags --libs shiboken6").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", *shiboken_flags, *pyincludes, *pylib, "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/sources/pyside6/qtexampleicons/CMakeLists.txt b/sources/pyside6/qtexampleicons/CMakeLists.txt
index 1562f7b..0611399 100644
--- a/sources/pyside6/qtexampleicons/CMakeLists.txt
+++ b/sources/pyside6/qtexampleicons/CMakeLists.txt
@@ -32,6 +32,8 @@ elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
     target_compile_definitions(QtExampleIcons PRIVATE "-DNDEBUG")
 endif()

+get_property(SHIBOKEN_PYTHON_INCLUDE_DIRS GLOBAL PROPERTY shiboken_python_include_dirs)
+
 target_include_directories(QtExampleIcons PRIVATE ${SHIBOKEN_PYTHON_INCLUDE_DIRS})

 get_property(SHIBOKEN_PYTHON_LIBRARIES GLOBAL PROPERTY shiboken_python_libraries)
