class Pyside < Formula
  include Language::Python::Virtualenv

  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.2.4-src/pyside-setup-opensource-src-6.2.4.tar.xz"
  sha256 "d9680ff298ee8b01a68de20911c60da04568a0918b3062d4c571ef170b4603ff"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "9cea688bda5a035c77b8a29082299afa6ca5631f40a595edcebfcd620cc12aec"
    sha256 cellar: :any, arm64_big_sur:  "50cf359b927d953109db619829781d08d91ae955f6dae91d84873ae45d5447a2"
    sha256 cellar: :any, monterey:       "07b7313eb6dae6cce800a3979fddca8c8a80411f5390b175fe5716d3aea1743e"
    sha256 cellar: :any, big_sur:        "fb4e1508f78608ed78fedb54698d145071a4163b3ecb598c128eef9c7930c06c"
    sha256 cellar: :any, catalina:       "a7ba2a9575b211c8a160f5f0aeaba8c2c212e383fb99edd483329f50c8509edb"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on xcode: :build
  depends_on "llvm"
  depends_on "python@3.9"
  depends_on "qt"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  fails_with gcc: "5"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  def install
    # upstream issue: https://bugreports.qt.io/browse/PYSIDE-1684
    inreplace "sources/pyside6/cmake/Macros/PySideModules.cmake",
              "${shiboken_include_dirs}",
              "${shiboken_include_dirs}:#{Formula["qt"].opt_include}"

    python = Formula["python@3.9"]
    venv = virtualenv_create(buildpath/"venv", python.opt_bin/"python3")
    venv.pip_install resources

    qt = Formula["qt"]
    site_packages = prefix/Language::Python.site_packages(python.opt_bin/"python3")
    site_pyside = site_packages/"PySide6"
    pyside_args = %w[
      --no-examples
      --no-qt-tools
      --rpath @loader_path/../shiboken6
      --shorter-paths
      --skip-docs
    ]
    system buildpath/"venv/bin/python3", *Language::Python.setup_install_args(prefix), *pyside_args

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
