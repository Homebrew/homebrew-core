class Pyside < Formula
  include Language::Python::Virtualenv

  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.4.2-src/pyside-setup-opensource-src-6.4.2.tar.xz"
  sha256 "1ec9d0936332efd229650cf10fed36cadddff7a613a2ea6e897de4d504c1b505"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a5ba0279810f7f827cc713b08b46ff7ec6b223b2e5888df1ecbf5fdc73b85c32"
    sha256 cellar: :any, arm64_monterey: "632ca9e007e0a5f7597e8573d8d46352dadbe17624f00b6421a49fa3a6a662d4"
    sha256 cellar: :any, arm64_big_sur:  "66002cffac46a0a027f2fe3e4fef79d1084cd06ec84d54badcf8a5962fe82d30"
    sha256 cellar: :any, ventura:        "612319efea821f1c6bdbcbca5793e6bb4bb85ecefde0138476b209662b721735"
    sha256 cellar: :any, monterey:       "8aae58fe85d5c70fbe3c77f76bf2051cc2470ec79dd00121d7be83a8edc78d8c"
    sha256 cellar: :any, big_sur:        "4f17b94ea0868a89eab2b7a4a0834ed388f0d2d875e32da41ce7af7c893d6799"
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
