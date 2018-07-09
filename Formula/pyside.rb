class Pyside < Formula
  desc "Qt binding for Python"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.11.0-src/pyside-setup-everywhere-src-5.11.0.tar.xz"
  sha256 "fbc412c4544bca308291a08a5173a949ca530d801f00b8337902a5067e490922"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "python"
  depends_on "python@2"
  depends_on "qt"

  # Edited patch to fix clang header include issue in 5.11.0, safe to remove once 5.11.1 is released
  # http://code.qt.io/cgit/pyside/pyside-setup.git/commit/?h=5.11.0&id=5662706937bd6a1449538539e3a503c6cbc45399
  patch do
    url "https://raw.githubusercontent.com/albertosottile/formula-patches/f327f197/pyside/pyside-homebrew.patch"
    sha256 "3a6a62ae8d4a7ab34f9ca66b5358e45a5e08c66f327f635f901bb68d6f97c8a4"
  end

  # Patch to add Python 3.7 support on 5.11.0, safe to remove once 5.11.1 is released
  # https://code.qt.io/cgit/pyside/pyside-setup.git/commit/?h=5.11&id=4a32f9d00b043b7255b590b95e9b35e9de44c4ed
  patch do
    url "https://code.qt.io/cgit/pyside/pyside-setup.git/patch/?id=4a32f9d00b043b7255b590b95e9b35e9de44c4ed"
    sha256 "3b88c02242172c7f58626bcb670fd0e2ef3259f628d50b755967c5dfb37e8a3b"
  end

  def install
    py3_version = Language::Python.major_minor_version "python3"
    py3_args = %W[
      --ignore-git
      --no-examples
      --macos-use-libc++
      --jobs=#{ENV.make_jobs}
      --install-lib #{lib}/python#{py3_version}/site-packages
      --install-scripts #{bin}
    ]

    py3_dest_path=lib/"python#{py3_version}/site-packages"
    py3_dest_path.mkpath

    system "python3", *Language::Python.setup_install_args(prefix), *py3_args
    (py3_dest_path/"homebrew-pyside.pth").write "#{py3_dest_path}\n"

    py2_version = Language::Python.major_minor_version "python2"
    py2_args = %W[
      --ignore-git
      --no-examples
      --macos-use-libc++
      --jobs=#{ENV.make_jobs}
      --install-lib #{lib}/python#{py2_version}/site-packages
      --install-scripts #{bin}
    ]

    py2_dest_path=lib/"python#{py2_version}/site-packages"
    py2_dest_path.mkpath

    system "python2", *Language::Python.setup_install_args(prefix), *py2_args
    (py2_dest_path/"homebrew-pyside.pth").write "#{py2_dest_path}\n"
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

    system "python2", "-c", "import PySide2"
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
    ].each { |mod| system "python2", "-c", "import PySide2.Qt#{mod}" }
  end
end
