class PysideAT2 < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.16-src/pyside-setup-opensource-src-5.15.16.tar.xz"
  sha256 "6d3ed6fd17275ea74829ab56df9c2e7641bfca6b5b201cf244998fa81cf07360"
  # NOTE: We omit some licenses:
  # 1. LICENSE.COMMERCIAL is removed from "OR" options as non-free
  # 2. GFDL-1.3-only is only used by not installed docs, e.g. sources/{pyside2,shiboken2}/doc
  # 3. BSD-3-Clause is only used by not installed examples
  license all_of: [
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
  ]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside2/"
    regex(%r{href=.*?PySide2[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "306fed8cdc3df64383e383bc48f5a890f2097e6b9d6931df1db6f3f4db8c2ceb"
    sha256 cellar: :any,                 arm64_sonoma:  "11ee1dbaa5ca85382f669e72b4cd8de39d7468c2b3634e4c324bea235d097f9e"
    sha256 cellar: :any,                 arm64_ventura: "03368c735c411d97738b675829caf91040ee7c2cab0dce9ed6f59ca75ed9df74"
    sha256 cellar: :any,                 sonoma:        "e7c5048a3bc60c86038cda301239cb00f5442c693b8fe6d164d55e9d9a9600bb"
    sha256 cellar: :any,                 ventura:       "e7c2d3c4175db918d43d300206d628d8f2a1074e54ef5bbe36b9d80548bd64b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b2bd5978ba6c32184505241867615f67125ba4e597ac23a98be767e265c492d"
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
