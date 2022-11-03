class PysideAT2 < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.7-src/pyside-setup-opensource-src-5.15.7.tar.xz"
  sha256 "f61210ae24e6882d5d0ca0059229e5dc4f35e2bca92dd6caf96c0f41943a8294"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside2/"
    regex(%r{href=.*?PySide2[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "160ad065834104b2a9f3077f49f7c2fe05784442e8ccb8b20dd2a1e7e6082592"
    sha256 cellar: :any,                 arm64_monterey: "bedee071b741dde0d9fff218d2c0d3eb282df78042f8461806258e03803ce4d2"
    sha256 cellar: :any,                 arm64_big_sur:  "9127707bb8b25282e612d3360ad9467b6528716a61dcb8541637994a5c76bb39"
    sha256 cellar: :any,                 ventura:        "0d98b1c6b7156df258d4f432d8192a2ea4a2f2a5e97e834c6d56a4d5f6ace974"
    sha256 cellar: :any,                 monterey:       "ab98e21f4ad696786804474dbca16cf4f4868ada27d26306885111a3060d7e6b"
    sha256 cellar: :any,                 big_sur:        "6f7cb05f3476f4b8f3c0d414d65ae72592ef5ea363219d196fac461fe3e9b13b"
    sha256 cellar: :any,                 catalina:       "41cda4203982c1700e69a91dd5e5fcc8d56ec2016f53c71f0658a6b4b59a9e85"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "python@3.10"
  depends_on "qt@5"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "libxcb"
    depends_on "mesa"
  end

  fails_with gcc: "5"

  # Don't copy qt@5 tools.
  patch do
    url "https://src.fedoraproject.org/rpms/python-pyside2/raw/009100c67a63972e4c5252576af1894fec2e8855/f/pyside2-tools-obsolete.patch"
    sha256 "ede69549176b7b083f2825f328ca68bd99ebf8f42d245908abd320093bac60c9"
  end

  # Fix build using ArchLinux patch. The corresponding code in shiboken6 was modified
  # in a later commit. Can remove when upstream decides to backport a fix to shiboken2.
  # Ref: https://codereview.qt-project.org/c/pyside/pyside-setup/+/365002
  patch do
    url "https://raw.githubusercontent.com/archlinux/svntogit-packages/7a6b2d1862ed9cbdd7ebcbcc9d6635e67cd1feab/trunk/fix-build.patch"
    sha256 "4f8815840b5df2e1e3b9f201a3402126821b0d9702920cefdc18050639143ad1"
  end

  # Fix error: use of undeclared identifier 'NPY_ARRAY_UPDATEIFCOPY'.
  # Remove in v5.15.10 as PYSIDE-2035 mentions fix was backported there.
  # Ref: https://codereview.qt-project.org/c/pyside/pyside-setup/+/418321
  # Ref: https://bugreports.qt.io/browse/PYSIDE-2035
  patch :p3 do
    url "https://code.qt.io/cgit/pyside/pyside-setup.git/patch/sources/shiboken6/libshiboken/sbknumpyarrayconverter.cpp?id=1422cf4a7f277fb13fd209f24a90d6c02641497d"
    sha256 "8f80bc04be1e22cf3279f8893159d8e7d6f86a6b1021808ff8942549944df40c"
    directory "sources/shiboken2"
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
                    "-DFORCE_LIMITED_API=yes",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python = which(python3)
    ENV.append_path "PYTHONPATH", prefix/Language::Python.site_packages(python)

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

    (testpath/"test.cpp").write <<~EOS
      #include <shiboken.h>
      int main()
      {
        Py_Initialize();
        Shiboken::AutoDecRef module(Shiboken::Module::import("shiboken2"));
        assert(!module.isNull());
        return 0;
      }
    EOS
    rpaths = []
    rpaths += ["-Wl,-rpath,#{lib}", "-Wl,-rpath,#{Formula["python@3.10"].opt_lib}"] unless OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp",
           "-I#{include}/shiboken2", "-L#{lib}", "-lshiboken2.abi3", *rpaths,
           *pyincludes, *pylib, "-o", "test"
    system "./test"
  end
end
