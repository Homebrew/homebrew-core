class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.1-src/pyside-setup-opensource-src-5.15.1.tar.xz"
  sha256 "f175c1d8813257904cf0efeb58e44f68d53b9916f73adaf9ce19514c0271c3fa"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]
  revision 1

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside2/"
    regex(%r{href=.*?PySide2[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 "c37639d922a1d35bc3d40872ce27f1cfb013b5cae290976c457b376f61ea1b58" => :catalina
    sha256 "c1fdd8ce48db4fb1e026564a7f2920ba9e270e8c3be68e61cf0a2e11bf45cfe0" => :mojave
    sha256 "928c5a2281bc65df8b2df534b8b2027bad5248a4b467f2a3389551ec8074eab7" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "python@3.9"
  depends_on "qt"

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    args = %W[
      --ignore-git
      --parallel=#{ENV.make_jobs}
      --install-scripts #{bin}
    ]

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"

    system Formula["python@3.9"].opt_bin/"python3",
           *Language::Python.setup_install_args(prefix),
           "--install-lib", lib/"python#{xy}/site-packages", *args,
           "--build-type=shiboken2"

    system Formula["python@3.9"].opt_bin/"python3",
           *Language::Python.setup_install_args(prefix),
           "--install-lib", lib/"python#{xy}/site-packages", *args,
           "--build-type=pyside2"

    lib.install_symlink Dir.glob(lib/"python#{xy}/site-packages/PySide2/*.dylib")
    lib.install_symlink Dir.glob(lib/"python#{xy}/site-packages/shiboken2/*.dylib")
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide2"
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
    ].each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide2.Qt#{mod}" }
  end
end
