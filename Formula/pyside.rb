class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.12.1-src/pyside-setup-everywhere-src-5.12.1.tar.xz"
  sha256 "6e26b6240b97558b8bf3c97810e950ef4121a03a1ebdecfb649992a505f18059"

  bottle do
    sha256 "e7fe88572d06f3466c7292847c31ba8597b2708d5785c63e18353bd9143a7738" => :mojave
    sha256 "6a26cc11e5ac8fdad247545ca6da90f0aed371480647c84de0332085f2d4734f" => :high_sierra
    sha256 "f597396d4f95f91c9262c8dc0a7e7f4d01ec6912db8bdff1af5e6b2baa91394b" => :sierra
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm"
  depends_on "python"
  depends_on "python@2"
  depends_on "qt"

  def install
    args = %W[
      --no-user-cfg
      install
      --prefix=#{prefix}
      --install-scripts=#{bin}
      --single-version-externally-managed
      --record=installed.txt
      --ignore-git
      --parallel=#{ENV.make_jobs}
    ]

    xy = Language::Python.major_minor_version "python3"

    system "python3", "setup.py", *args,
           "--install-lib", lib/"python#{xy}/site-packages"

    lib.install_symlink Dir.glob(lib/"python#{xy}/site-packages/PySide2/*.dylib")
    lib.install_symlink Dir.glob(lib/"python#{xy}/site-packages/shiboken2/*.dylib")

    system "python2", "setup.py", *args,
           "--install-lib", lib/"python2.7/site-packages"

    lib.install_symlink Dir.glob(lib/"python2.7/site-packages/PySide2/*.dylib")
    lib.install_symlink Dir.glob(lib/"python2.7/site-packages/shiboken2/*.dylib")

    pkgshare.install "examples/samplebinding", "examples/utils"
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
    ["python", "python@2"].each do |python|
      if python == "python@2"
        ENV.prepend_path "PATH", Formula["python@2"].opt_libexec/"bin"
      end
      system "cmake", "-H#{pkgshare}/samplebinding",
                      "-B.",
                      "-G",
                      "Unix Makefiles",
                      "-DCMAKE_BUILD_TYPE=Release"
      system "make"
      system "make", "clean"
      rm "CMakeCache.txt"
    end
  end
end
