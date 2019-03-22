class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.12.3-src/pyside-setup-everywhere-src-5.12.3.tar.xz"
  sha256 "4f7aab7d4bbaf1b3573cc989d704e87b0de55cce656ae5e23418a88baa4c6842"

  bottle do
    sha256 "e7fe88572d06f3466c7292847c31ba8597b2708d5785c63e18353bd9143a7738" => :mojave
    sha256 "6a26cc11e5ac8fdad247545ca6da90f0aed371480647c84de0332085f2d4734f" => :high_sierra
    sha256 "f597396d4f95f91c9262c8dc0a7e7f4d01ec6912db8bdff1af5e6b2baa91394b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "python"
  depends_on "python@2"
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

    system "python2", *Language::Python.setup_install_args(prefix),
           "--install-lib", lib/"python2.7/site-packages", *args,
           "--build-type=shiboken2"

    system "python2", *Language::Python.setup_install_args(prefix),
           "--install-lib", lib/"python2.7/site-packages", *args,
           "--build-type=pyside2"

    lib.install_symlink Dir.glob(lib/"python2.7/site-packages/PySide2/*.dylib")
    lib.install_symlink Dir.glob(lib/"python2.7/site-packages/shiboken2/*.dylib")
  end

  test do
    ["python3", "python2"].each do |python|
      system python, "-c", "import PySide2"
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
      ].each { |mod| system python, "-c", "import PySide2.Qt#{mod}" }
    end
  end
end
