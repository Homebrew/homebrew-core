class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.2.1-src/pyside-setup-opensource-src-6.2.1.tar.xz"
  sha256 "e0df6f42ed92e039d44ae9bf7d23cc4ee2fc4722c87adddbeafc6376074c4cd4"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "e64072ce6b1dd9a42c137770a55cc8f1882c659336c168ad6a6123fe8572c37f"
    sha256 cellar: :any, arm64_big_sur:  "8698a6cf92f1fd25fb9d0a7d3277e36e673af2d9b866595de1e17ae8483cf9de"
    sha256 cellar: :any, monterey:       "d32fd7d63ec4aa65d2e973fc674063891c490dbeb61d0b794a904400fbea1ba4"
    sha256 cellar: :any, big_sur:        "2ea9e43fcf8b6a83ab2d7559e79eba7020ae9633c3d1d91c7f758134c67218ec"
    sha256 cellar: :any, catalina:       "72fd0602f5aa49c016c9bd96a65f9fe3166deb3440da7790a816925f10e9de61"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on xcode: :build
  depends_on "llvm"
  depends_on "python@3.9"
  depends_on "qt"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    # upstream issue: https://bugreports.qt.io/browse/PYSIDE-1684
    inreplace "sources/pyside6/cmake/Macros/PySideModules.cmake",
              "${shiboken_include_dirs}",
              "${shiboken_include_dirs}:#{Formula["qt"].opt_include}"

    qt = Formula["qt"]
    site_packages = prefix/Language::Python.site_packages("python3")
    site_pyside = site_packages/"PySide6"
    pyside_args = %w[
      --no-examples
      --no-qt-tools
      --rpath @loader_path/../shiboken6
      --shorter-paths
      --skip-docs
    ]
    system "python3", *Language::Python.setup_install_args(prefix), *pyside_args

    # install tools symlinks
    %w[lupdate lrelease].each { |x| ln_s (qt.opt_bin/x).relative_path_from(site_pyside), site_pyside }
    mkdir_p site_pyside/"Qt/libexec"
    %w[uic rcc].each do |x|
      ln_s (qt.opt_pkgshare/"libexec"/x).relative_path_from(site_pyside/"Qt/libexec"), site_pyside/"Qt/libexec"
    end
    %w[assistant linguist].each { |x| ln_s (qt.opt_bin/x).relative_path_from(site_pyside), site_pyside }
    ln_s (qt.opt_libexec/"Designer.app").relative_path_from(site_pyside), site_pyside
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide6"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import shiboken6"

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
    modules << "WebEngineCore" if OS.mac? && (DevelopmentTools.clang_build_version > 1200)

    modules.each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide6.Qt#{mod}" }

    pyincludes = shell_output("#{Formula["python@3.9"].opt_bin}/python3-config --includes").chomp.split
    pylib = shell_output("#{Formula["python@3.9"].opt_bin}/python3-config --ldflags --embed").chomp.split
    pyver = Language::Python.major_minor_version(Formula["python@3.9"].opt_bin/"python3").to_s.delete(".")
    site_packages = prefix/Language::Python.site_packages("python3")

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
           "-I#{site_packages}/shiboken6_generator/include", "-L#{site_packages}/shiboken6",
           "-lshiboken6.cpython-#{pyver}-darwin.#{version.major_minor}",
           *pyincludes, *pylib, "-o", "test"
    system "./test"
  end
end
