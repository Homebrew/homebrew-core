class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.13.0-src/pyside-setup-everywhere-src-5.13.0.tar.xz"
  sha256 "8e47e778a6c8ee86e9bc7dbf56371cf607e9f3c1a03a7d6df9e34f8dba555782"
  revision 1

  bottle do
    sha256 "7f5196abed2367fe167bafee9d684855c458215f0459ecaa26e56f251f4ca482" => :mojave
    sha256 "9913e73b0df42cc6248a9a03bb40b3ded4fc35cf90b382455cc78835827ac74a" => :high_sierra
    sha256 "28a05e906f3957f748351d354d5df186b6c54d14184b044ea40db748cd0f3109" => :sierra
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
