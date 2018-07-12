class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.11.0-src/pyside-setup-everywhere-src-5.11.0.tar.xz"
  sha256 "fbc412c4544bca308291a08a5173a949ca530d801f00b8337902a5067e490922"

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

  # Remove for > 5.11.0
  # Edited patch to fix clang header include issue in 5.11.0
  # See http://code.qt.io/cgit/pyside/pyside-setup.git/commit/?h=5.11.0&id=5662706937bd6a1449538539e3a503c6cbc45399
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/7895c8a/pyside/pyside-homebrew.patch"
    sha256 "3a6a62ae8d4a7ab34f9ca66b5358e45a5e08c66f327f635f901bb68d6f97c8a4"
  end

  # Remove for > 5.11.0
  # Patch to add Python 3.7 support on 5.11.0
  # See https://code.qt.io/cgit/pyside/pyside-setup.git/commit/?h=5.11&id=4a32f9d00b043b7255b590b95e9b35e9de44c4ed
  patch do
    url "https://code.qt.io/cgit/pyside/pyside-setup.git/patch/?id=4a32f9d00b043b7255b590b95e9b35e9de44c4ed"
    sha256 "3b88c02242172c7f58626bcb670fd0e2ef3259f628d50b755967c5dfb37e8a3b"
  end

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
