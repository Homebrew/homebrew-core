class Pyside < Formula
  include Language::Python::Virtualenv

  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.3.2-src/pyside-setup-opensource-src-6.3.2.tar.xz"
  sha256 "d19979589e8946488e1b5e01ac0da75ab73b40c901726723335e160241a56892"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "25fd825221a25b46ff164af5c8c93042c8e1fb5cba5c0d426c5e87f41017ab37"
    sha256 cellar: :any,                 arm64_big_sur:  "baf3c75877821d8c92f050aa981cfa32778e9cfbcb9d589dad7e5ff9d6c351b7"
    sha256 cellar: :any,                 monterey:       "a03ec7f8ab8e0875abae89f8ac1cc7b915888f9d13888fceafed10377e4f5b7d"
    sha256 cellar: :any,                 big_sur:        "10502d70eb942cbf67495a6e2da010e81d580187bb68e55cf93ba7535a3f1739"
    sha256 cellar: :any,                 catalina:       "6e88e069a71fa03cd5240d48de4439e7719fc80f2598d3885a7574030b5f6e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e98ac0721a97ce1e55e41784ba637914555ab24eb8ee9d214c292ff66deea3b3"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on xcode: :build
  depends_on "llvm"
  depends_on "python@3.10"
  depends_on "qt"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "mesa"
  end

  fails_with gcc: "5"

  def python3
    "python3.10"
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

    args = std_cmake_args + [
      "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_lib}",
      "-DPYTHON_EXECUTABLE=#{which(python3)}",
      "-DBUILD_TESTS=OFF",
      "-DNO_QT_TOOLS=yes",
      "-DCMAKE_INSTALL_RPATH=#{lib}",
      "-DFORCE_LIMITED_API=yes",
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    mv bin/"metaobjectdump.py", pkgshare
    mv bin/"project.py", pkgshare
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

    python3_config = Formula["python@3.10"].opt_bin/"#{python3}-config"
    pyincludes = shell_output("#{python3_config} --includes").chomp.split
    pylib = shell_output("#{python3_config} --ldflags --embed").chomp.split
    if OS.linux?
      pylib += %W[
        -Wl,-rpath,#{Formula["python@3.10"].opt_lib}
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
