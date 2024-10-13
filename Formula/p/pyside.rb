class Pyside < Formula
  include Language::Python::Virtualenv

  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.7.3-src/pyside-setup-everywhere-src-6.7.3.tar.xz"
  sha256 "a4c414be013d5051a2d10a9a1151e686488a3172c08a57461ea04b0a0ab74e09"
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
    sha256 cellar: :any, arm64_sonoma:  "c68e9ffe44861c52ec2190a21ca5d50e6122bb8d91087c950ba23132d44a6c42"
    sha256 cellar: :any, arm64_ventura: "ef11438a72f6dc75f50951241eeb5ef95a6011078b73bb0c3389f28fe35c8bb1"
    sha256 cellar: :any, sonoma:        "08290c31434dc6f115eb7f53f92540a347b693b5d125aa2f8935358bff04adb0"
    sha256 cellar: :any, ventura:       "ed319e06e865311c2a788b94528034cb1e59023fef6e621a84638f28915c095c"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on xcode: :build
  depends_on "llvm"
  depends_on "python@3.12"
  depends_on "qt"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "mesa"
  end

  fails_with gcc: "5"

  # Fix .../sources/pyside6/qtexampleicons/module.c:4:10: fatal error: 'Python.h' file not found
  # Upstream issue: https://bugreports.qt.io/browse/PYSIDE-2491
  patch :DATA

  def python3
    "python3.12"
  end

  def install
    ENV.append_path "PYTHONPATH", buildpath/"build/sources"

    extra_include_dirs = [Formula["qt"].opt_include]
    extra_include_dirs << Formula["mesa"].opt_include if OS.linux?

    # upstream issue: https://bugreports.qt.io/browse/PYSIDE-1684
    inreplace "sources/pyside6/cmake/Macros/PySideModules.cmake",
              "${shiboken_include_dirs}",
              "${shiboken_include_dirs}:#{extra_include_dirs.join(":")}"

    # Fix build failure on macOS because `CMAKE_BINARY_DIR` points to /tmp but
    # `location` points to `/private/tmp`, which makes this conditional fail.
    # Submitted upstream here: https://codereview.qt-project.org/c/pyside/pyside-setup/+/416706.
    inreplace "sources/pyside6/PySide6/__init__.py.in",
              "in_build = Path(\"@CMAKE_BINARY_DIR@\") in location.parents",
              "in_build = Path(\"@CMAKE_BINARY_DIR@\").resolve() in location.parents"

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
                     "-DFORCE_LIMITED_API=yes",
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
    modules << "WebEngineCore" if OS.linux? || (DevelopmentTools.clang_build_version > 1200)
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

    (testpath/"test.cpp").write <<~EOS
      #include <shiboken.h>
      int main()
      {
        Py_Initialize();
        Shiboken::AutoDecRef module(Shiboken::Module::import("shiboken6"));
        assert(!module.isNull());
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp",
                    "-I#{include}/shiboken6",
                    "-L#{lib}", "-lshiboken6.abi3",
                    *pyincludes, *pylib, "-o", "test"
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
