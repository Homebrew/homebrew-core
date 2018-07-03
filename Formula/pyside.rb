class Pyside < Formula
  desc "Qt binding for Python"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.11.0-src/pyside-setup-everywhere-src-5.11.0.tar.xz"
  sha256 "fbc412c4544bca308291a08a5173a949ca530d801f00b8337902a5067e490922"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "python@2"
  depends_on "qt"

  # Patch to correct clang header include issue in PySide 5.11.0
  # https://bugreports.qt.io/browse/PYSIDE-731
  patch do
    url "http://syncplay.s3.amazonaws.com/pyside-clang-header.diff"
    sha256 "d3472787b0b67b60d1f7882f2871404b1826677cd96188de9cb0b54f1f4285fc"
  end

  def install
    dest_path=lib/"python2.7/site-packages"
    dest_path.mkpath

    args = %W[
      install
      --ignore-git
      --no-examples
      --macos-use-libc++
      --jobs=#{ENV.make_jobs}
      --install-lib #{lib}/python2.7/site-packages
      --install-scripts #{bin}
    ]
    system "python", *Language::Python.setup_install_args(prefix), *args
    (dest_path/"homebrew-pyside.pth").write "#{dest_path}\n"
  end

  test do
    system "python", "-c", "import PySide2"
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
    ].each { |mod| system "python", "-c", "import PySide2.Qt#{mod}" }
  end
end
