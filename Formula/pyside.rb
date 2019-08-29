class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.13.0-src/pyside-setup-everywhere-src-5.13.0.tar.xz"
  sha256 "8e47e778a6c8ee86e9bc7dbf56371cf607e9f3c1a03a7d6df9e34f8dba555782"
  revision 1

  bottle do
    sha256 "33fe98a04017c78cd5bb34f9fc4a2286cbfd8b601e1e3eb90bdba1f844dbdab1" => :mojave
    sha256 "d02725c6dba0b007a59a62372f42f245ad4ce8c62bdbec717b6479f4a87aabf1" => :high_sierra
    sha256 "f5a297f76c83145629c1dec3e5770b547286dea2b4f397e94d5319c728f70508" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "python"
  depends_on "qt"

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    args = %W[
      --ignore-git
      --parallel=#{ENV.make_jobs}
      --install-scripts #{bin}
    ]

    xy = Language::Python.major_minor_version "python3"

    system "python3", *Language::Python.setup_install_args(prefix),
           "--install-lib", lib/"python#{xy}/site-packages", *args,
           "--build-type=shiboken2"

    system "python3", *Language::Python.setup_install_args(prefix),
           "--install-lib", lib/"python#{xy}/site-packages", *args,
           "--build-type=pyside2"

    lib.install_symlink Dir.glob(lib/"python#{xy}/site-packages/PySide2/*.dylib")
    lib.install_symlink Dir.glob(lib/"python#{xy}/site-packages/shiboken2/*.dylib")
  end

  test do
    system "python3", "-c", "import PySide2"
    %w[
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
    ].each { |mod| system "python3", "-c", "import PySide2.Qt#{mod}" }
  end
end
