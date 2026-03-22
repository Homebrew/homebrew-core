class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.10.2-src/pyside-setup-everywhere-src-6.10.2.tar.xz"
  mirror "https://cdimage.debian.org/mirror/qt.io/qtproject/official_releases/QtForPython/pyside6/PySide6-6.10.2-src/pyside-setup-everywhere-src-6.10.2.tar.xz"
  sha256 "05eec38bb71bffff8860786e3c0766cc4b86affc72439bd246c54889bdcb7400"
  # NOTE: We omit some licenses even though they are in SPDX-License-Identifier or LICENSES/ directory:
  # 1. LicenseRef-Qt-Commercial is removed from "OR" options as non-free
  # 2. GFDL-1.3-no-invariants-only is only used by not installed docs, e.g. sources/{pyside6,shiboken6}/doc
  # 3. BSD-3-Clause is only used by not installed examples, tutorials and build scripts
  # 4. Apache-2.0 is only used by not installed examples
  license all_of: [
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
  ]
  revision 2

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256                               arm64_tahoe:   "1d31e4d4410de481977b89ba7fc1c57dece74cd4064bbc35486cac7e40c7957b"
    sha256                               arm64_sequoia: "14b5da211c69305c1494aedba826d2237a3f85c4fa605c07c3dcd248079d18b3"
    sha256                               arm64_sonoma:  "0d52dd47d88606f1ce919d446bb9f4790347e6a420fc93795daebd8567f30d30"
    sha256 cellar: :any,                 sonoma:        "1e3394704be6e83f8d192f5d082e640d590a72bb32f55056f81b49ca672d0670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c68c71db54c96b7d1aad68214b422b5a14b0faf71847152a8c6b74896e339d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9850022e3918536a2fb7896ff48db57e704cab0d8bd5e92017853105ce11000c"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "qtshadertools" => :build
  depends_on xcode: :build
  depends_on "pkgconf" => :test

  depends_on "llvm"
  depends_on "python@3.14"
  depends_on "qt3d"
  depends_on "qtbase"
  depends_on "qtcharts"
  depends_on "qtconnectivity"
  depends_on "qtdatavis3d"
  depends_on "qtdeclarative"
  depends_on "qtgraphs"
  depends_on "qthttpserver"
  depends_on "qtlocation"
  depends_on "qtmultimedia"
  depends_on "qtnetworkauth"
  depends_on "qtpositioning"
  depends_on "qtquick3d"
  depends_on "qtremoteobjects"
  depends_on "qtscxml"
  depends_on "qtsensors"
  depends_on "qtserialbus"
  depends_on "qtserialport"
  depends_on "qtspeech"
  depends_on "qtsvg"
  depends_on "qttools"
  depends_on "qtwebchannel"
  depends_on "qtwebsockets"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "qtshadertools"
  end

  on_sonoma :or_newer do
    depends_on "qtwebengine"
    depends_on "qtwebview"
  end

  on_linux do
    depends_on "mesa"

    # TODO: Add dependencies on all Linux when `qtwebengine` is bottled on arm64 Linux
    on_intel do
      depends_on "qtwebengine"
      depends_on "qtwebview"
    end
  end

  def python3
    "python3.14"
  end

  def install
    ENV.append_path "PYTHONPATH", buildpath/"build/sources"

    extra_include_dirs = [Formula["qttools"].opt_include]

    # upstream issue: https://bugreports.qt.io/browse/PYSIDE-1684
    inreplace "sources/pyside6/cmake/Macros/PySideModules.cmake",
              "${shiboken_include_dirs}",
              "${shiboken_include_dirs}:#{extra_include_dirs.join(":")}"

    # Install python scripts into pkgshare rather than bin
    inreplace "sources/pyside-tools/CMakeLists.txt", "DESTINATION bin", "DESTINATION #{pkgshare}"

    # Avoid shim reference
    inreplace "sources/shiboken6/ApiExtractor/CMakeLists.txt", "${CMAKE_CXX_COMPILER}", ENV.cxx

    shiboken6_module = prefix/Language::Python.site_packages(python3)/"shiboken6"

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{rpath(source: shiboken6_module)}",
                    "-DPython_EXECUTABLE=#{which(python3)}",
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
    modules << "WebEngineCore" if (OS.linux? && Hardware::CPU.intel?) || (OS.mac? && MacOS.version >= :sonoma)
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
