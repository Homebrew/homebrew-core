class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.12.0-src/pyside-setup-everywhere-src-5.12.0.tar.xz"
  sha256 "890149628a6c722343d6498a9f7e1906ce3c10edcaef0cc53cd682c1798bef51"

  bottle do
    sha256 "4d0afc4ec29bb5038b9200401533617c726dfcdf9734ce6d0d7946ccf6448ade" => :mojave
    sha256 "282a171f80a2f6eadd354e868077759a702595396e5f2e0bfdd638509c4d5e6b" => :high_sierra
    sha256 "1a9e043fb1993fb2673f4aeb947fac0d87fe862e922a387f268249d2bdcaf7d1" => :sierra
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
      if python == "python"
        ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"
      end
      system "cmake", "-H#{pkgshare}/samplebinding",
                      "-B.",
                      "-G",
                      "Unix Makefiles",
                      "-DCMAKE_BUILD_TYPE=Release"
      system "make"
      system "make", "clean"
    end
  end
end
