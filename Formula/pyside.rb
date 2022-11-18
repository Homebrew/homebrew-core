class Pyside < Formula
  include Language::Python::Virtualenv

  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.4.0.1-src/pyside-setup-opensource-src-6.4.0.tar.xz"
  version "6.4.0.1"
  sha256 "6e5be5defccacd21ec7e2579d6d6493366dd8e00f8899746abd174f1eb1eff14"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 arm64_ventura:  "dffbf25bf38b3fe04450096e9dadebae039a805aab71b34f3ca52c64b9185555"
    sha256 arm64_monterey: "e57c3a873abd31a3dc62c7fa2ea13602ce55e5dcd2aaa6ec3060ea66ff4f895f"
    sha256 arm64_big_sur:  "2826b9af79bce4a0c637cce74ca0d51592e29d7f976ee20ff188dc7cc03f06ee"
    sha256 ventura:        "e26b777b21e4130aee323de0e8ae70d96131237f3e8907bd2dbc3249e96b2f27"
    sha256 monterey:       "9431f8fdbadf747ed47725a6db282924f8446cf165fbbc29d984c12ab8090e11"
    sha256 big_sur:        "71804120f03ca26ef7c430c4254f4c59c774624a5117d3726ddf8e274ef61dd6"
    sha256 catalina:       "104c59b3bbb34cb563bf65080c2a04d2b2872509c186dc88a4435f2e054026af"
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

    # Install python scripts into pkgshare rather than bin
    inreplace "sources/pyside-tools/CMakeLists.txt", "DESTINATION bin", "DESTINATION #{pkgshare}"

    args = std_cmake_args + [
      "-DCMAKE_CXX_COMPILER=#{ENV.cxx}",
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
