class Pyside < Formula
  include Language::Python::Virtualenv

  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.3.1-src/pyside-setup-opensource-src-6.3.1.tar.xz"
  sha256 "e5a85ed68834eb8324e3486283a9451b030d7221809e2a9533162e6b93899977"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a5770f6fc100fff402e1734b5e39acfbcac11242b79966a973e0a86c3f5339bb"
    sha256 cellar: :any,                 arm64_big_sur:  "9a0ce86e8aace24117c1146e273722c491c596dda70585342a5073bd803b9df7"
    sha256 cellar: :any,                 monterey:       "413ef77df4f6e8e36c02303c975740bd5ebb523f3588fc8d13f0518f88b6a985"
    sha256 cellar: :any,                 big_sur:        "3d9f779fcb696aaeaf93e17d46be4c3e143c9a5b4b7bab437bb69f1d130d748f"
    sha256 cellar: :any,                 catalina:       "596c7234a76a1a62a6c54a7febeb10fd208644bbafa6288fc70721bd781ac916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "534eb3b7659ba573fc265a38dc3ff05430b857b83d3a681a5ef1825d4fe525c2"
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
    depends_on "gcc"
    depends_on "mesa"
  end

  fails_with gcc: "5"

  # Apply upstream commit to fix build.  Remove with next release.
  patch do
    url "https://code.qt.io/cgit/pyside/pyside-setup.git/patch/?id=703d975f"
    sha256 "c8aa9518edb792793d30e7ee8b77bfbdc4c408bdb6ac4d208813092cdbf7f6ae"
  end

  def install
    ENV.append_path "PYTHONPATH", buildpath/"build/sources"

    extra_include_dirs = [Formula["qt"].opt_include]
    unless OS.mac?
      gcc_version = Formula["gcc"].version.major
      extra_include_dirs += [
        Formula["gcc"].opt_include/"c++"/gcc_version,
        Formula["gcc"].opt_include/"c++"/gcc_version/"x86_64-pc-linux-gnu",
        Formula["mesa"].opt_include,
      ]
    end

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
      "-DPYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_bin}/python3",
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
    system Formula["python@3.10"].opt_bin/"python3", "-c", "import PySide6"
    system Formula["python@3.10"].opt_bin/"python3", "-c", "import shiboken6"

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

    modules.each { |mod| system Formula["python@3.10"].opt_bin/"python3", "-c", "import PySide6.Qt#{mod}" }

    pyincludes = shell_output("#{Formula["python@3.10"].opt_bin}/python3-config --includes").chomp.split
    pylib = shell_output("#{Formula["python@3.10"].opt_bin}/python3-config --ldflags --embed").chomp.split
    pylib << "-Wl,-rpath,#{Formula["python@3.10"].opt_lib}" unless OS.mac?

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
