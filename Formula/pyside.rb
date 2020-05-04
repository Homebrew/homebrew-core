class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.14.2.1-src/pyside-setup-opensource-src-5.14.2.1.tar.xz"
  sha256 "11f48956208a487dabf6f531e60fb88ad0e48f2979cfc9e79c1c986387c491fa"

  bottle do
    sha256 "fea86f39d15b29aac8ed23fda31d69eb46a63f76b8a70da89b64f4398a97f32a" => :catalina
    sha256 "0a121ff7a1f1cdf1801f327fbedbf520939e73d417adba0e077513d0660a9148" => :mojave
    sha256 "df3df6b24b051d6132a87cdb09b5a40e6aee86248665c9c35ecdf71af1432ce6" => :high_sierra
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
