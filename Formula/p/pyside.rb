class Pyside < Formula
  include Language::Python::Virtualenv

  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.5.2-src/pyside-setup-everywhere-src-6.5.2.tar.xz"
  sha256 "90dbf1d14fcd41c98a7cbea44b8a4951e10d0b798e154749756e4946654d1ba8"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "2d55e2cac6cdedc533be9f1c38d2236d7bce53988542f76d96b96f1e62e8c305"
    sha256 cellar: :any, arm64_ventura:  "9aa2c6e8e92454251f4ef2ff53ba8badabc9a55381cfb7ebea44dfbbc9fd7966"
    sha256 cellar: :any, arm64_monterey: "63221c34119789913be3d22d1ea3d3fe7631f60aa35880677910b56e8dfb72d6"
    sha256 cellar: :any, arm64_big_sur:  "9ab03e7a12afefecd33ba2cd72e2228178d5a7de5866482d3c5a9f18a9f7543c"
    sha256 cellar: :any, sonoma:         "5d4ea0048af8a56b70f1e4885ec0a5891aef311b858a075d3801d8a513aa7404"
    sha256 cellar: :any, ventura:        "b76e848c2cac77f14cf96067002240b140f52b368ef74105f8584b5ec0b46a7e"
    sha256 cellar: :any, monterey:       "e480b45aa70deb7ebf47996b9dd1c186079039f740b70a075e85403af85972ed"
    sha256 cellar: :any, big_sur:        "46a22ccaa4b50f28e519e4b9c936bcbff00a4956f4165e96432b81dc5bc234d9"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on xcode: :build
  depends_on "llvm"
  depends_on "python@3.11"
  depends_on "qt"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "mesa"
  end

  fails_with gcc: "5"

  def python3
    "python3.11"
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
