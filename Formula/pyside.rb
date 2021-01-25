class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.2-src/pyside-setup-opensource-src-5.15.2.tar.xz"
  sha256 "b306504b0b8037079a8eab772ee774b9e877a2d84bab2dbefbe4fa6f83941418"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside2/"
    regex(%r{href=.*?PySide2[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    rebuild 1
    sha256 "b5fbef8f97a40637dde5e19d7d7748c68d6791aff605a9fbc727ec7ab9a59a20" => :big_sur
    sha256 "a7ad725f886a87be690a6dbd6f692c12ad80217ca4da32ae288835e65b8ebd2f" => :arm64_big_sur
    sha256 "21ee031fac323276085a0e50bf35bec8b21a1a048114d00143cecbc389c1f97b" => :catalina
    sha256 "51c56d621de2ecec0ba899fadf2243ceddf7461744f973c2e8c27f4c85d01633" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "python@3.9"
  depends_on "qt"

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    if MacOS.version == :big_sur
      # Sysconfig promotes '11' to an integer which confuses the build
      # system. See:
      #  * https://bugreports.qt.io/browse/PYSIDE-1469
      #  * https://codereview.qt-project.org/c/pyside/pyside-setup/+/328375
      inreplace "build_scripts/wheel_utils.py",
                "python_target_split = [int(x) for x in python_target.split('.')]",
                "python_target_split = [int(x) for x in str(python_target).split('.')]"
    end

    args = %W[
      --ignore-git
      --parallel=#{ENV.make_jobs}
      --install-scripts #{bin}
      --rpath=#{lib}
      --macos-sysroot=#{MacOS.sdk_path}
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
    modules = %w[
      Core
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      Widgets
      Xml
    ]

    # QT web engine is currently not supported on Apple
    # silicon. Re-enable it once it has been enabled in the qt.rb.
    modules << "WebEngineWidgets" unless Hardware::CPU.arm?

    modules.each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide2.Qt#{mod}" }
  end
end
