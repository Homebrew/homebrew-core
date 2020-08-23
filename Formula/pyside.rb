class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.0-src/pyside-setup-opensource-src-5.15.0.tar.xz"
  sha256 "f1cdee53de3b76e22c1117a014a91ed95ac16e4760776f4f12dc38cd5a7b6b68"

  bottle do
    sha256 "e57b255441e9cd1aeeb0af012c69d54829b6f6fb0306bfa91e46ad4cebe33817" => :catalina
    sha256 "926963a98a1d3490ccd21e91428edeef3fb13bd1a9062142625a94a69f1e0991" => :mojave
    sha256 "a0c49e08f6a7e2d8d2b6744672c90537c15f9b98846d35a83d599d2e819dc733" => :high_sierra
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
