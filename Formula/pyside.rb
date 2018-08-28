class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.11.1-src/pyside-setup-everywhere-src-5.11.1.tar.xz"
  sha256 "9cbc3cbb03c6c1ddba8de7a651c84b269f87ebd4a0991a1f9acc8b2d0ccdfb83"

  bottle do
    sha256 "8b9e5689c3a267f36d88cf2933a56cb9f93d4537edc3daafac89774846abf570" => :high_sierra
    sha256 "790da93c0c05e9bd0ff14d7f3a43b7f418d619da36caebcd6159d08a38daa2cd" => :sierra
    sha256 "fc26b8c47d5d2c1a4b51a7cc50e4b364b92c2ff1523efbfbb35cd6c39575e63d" => :el_capitan
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm"
  depends_on "python"
  depends_on "python@2"
  depends_on "qt"

  def install
    args = %W[
      --ignore-git
      --no-examples
      --macos-use-libc++
      --jobs=#{ENV.make_jobs}
      --install-scripts #{bin}
    ]

    xy = Language::Python.major_minor_version "python3"

    system "python3", *Language::Python.setup_install_args(prefix),
           "--install-lib", lib/"python#{xy}/site-packages", *args

    system "python2", *Language::Python.setup_install_args(prefix),
           "--install-lib", lib/"python2.7/site-packages", *args

    pkgshare.install "examples/samplebinding", "examples/utils"
  end

  test do
    ["python2", "python3"].each do |python|
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
    ["python@2", "python"].each do |python|
      if python == "python"
        ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"
      end
      system "cmake", "-H#{pkgshare}/samplebinding",
                      "-B.",
                      "-G",
                      "Unix Makefiles",
                      "-DCMAKE_BUILD_TYPE=Release"
      system "make"
    end
  end
end
