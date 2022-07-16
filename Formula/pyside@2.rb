class PysideAT2 < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.5-src/pyside-setup-opensource-src-5.15.5.tar.xz"
  sha256 "3920a4fb353300260c9bc46ff70f1fb975c5e7efa22e9d51222588928ce19b33"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ccd1901a866f8125d977d0f73513dec49b76fad77a4d91f0d22cbab8abefddf4"
    sha256 cellar: :any,                 arm64_big_sur:  "39f714aa8636607bac587c8cf768f0922c27a42881585892dd6b5af84ca3b749"
    sha256 cellar: :any,                 monterey:       "0aa9567489b0a540bfc750c6cb9fb0dc4a57769466291ed690d8b9a3af40b2c8"
    sha256 cellar: :any,                 big_sur:        "c5955be508ce42b9d637b0875c30bb26e324582318434f86647bc355b4306b88"
    sha256 cellar: :any,                 catalina:       "0a5fa4c6ac76e9b99cd59a2b99d41d64ff1fc5ca264498828c7f80e73d97e3ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4b7fa31aa6b94fc83035a0f27d3581a8e107ffc6ce2ad4eb665012ad2d3eb9b"
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

  def install
    rpaths = if OS.mac?
      site_packages = Language::Python.site_packages("python3")
      prefix_relative_path = prefix.relative_path_from(prefix/site_packages/"PySide2")
      [rpath, "@loader_path/#{prefix_relative_path}/lib"]
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

    args = std_cmake_args + %W[
      -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      -DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_lib}
      -DPYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_bin}/python3
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DFORCE_LIMITED_API=yes
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python = Formula["python@3.10"].opt_bin/"python3"
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
