class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.0-src/pyside-setup-opensource-src-5.15.0.tar.xz"
  sha256 "f1cdee53de3b76e22c1117a014a91ed95ac16e4760776f4f12dc38cd5a7b6b68"

  bottle do
    sha256 "18ec6fcaa7005bd0e3fcfbc4370937b54e4986e95de4cbdf8ef6b12e0467feaf" => :catalina
    sha256 "d6579289a18ab6182790e28d45d1ebc5163ef207214c295c76624ed987af7865" => :mojave
    sha256 "7784b961d333b71f56da8e77f3b7b5fa648a3336c37fda646bfec1cce7ff6797" => :high_sierra
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
