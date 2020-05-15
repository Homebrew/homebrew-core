class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.14.2.1-src/pyside-setup-opensource-src-5.14.2.1.tar.xz"
  sha256 "11f48956208a487dabf6f531e60fb88ad0e48f2979cfc9e79c1c986387c491fa"
  revision 1

  bottle do
    sha256 "d1b3b419b1346e3990cbc17de64acc68b28456ce299ca8859ae35506aa1908a9" => :catalina
    sha256 "27e6837fc74c63d56b1694fff75186142237dfc57c82f8a67dc9b0cbe9947a43" => :mojave
    sha256 "d989a79733b4578065300d36908be9debef8e6b504f46896f42cff3c324a9d82" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "python@3.8"
  depends_on "qt"

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    args = %W[
      --ignore-git
      --parallel=#{ENV.make_jobs}
      --install-scripts #{bin}
    ]

    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"

    system Formula["python@3.8"].opt_bin/"python3",
           *Language::Python.setup_install_args(prefix),
           "--install-lib", lib/"python#{xy}/site-packages", *args,
           "--build-type=shiboken2"

    system Formula["python@3.8"].opt_bin/"python3",
           *Language::Python.setup_install_args(prefix),
           "--install-lib", lib/"python#{xy}/site-packages", *args,
           "--build-type=pyside2"

    lib.install_symlink Dir.glob(lib/"python#{xy}/site-packages/PySide2/*.dylib")
    lib.install_symlink Dir.glob(lib/"python#{xy}/site-packages/shiboken2/*.dylib")
  end

  test do
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import PySide2"
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
    ].each { |mod| system Formula["python@3.8"].opt_bin/"python3", "-c", "import PySide2.Qt#{mod}" }
  end
end
