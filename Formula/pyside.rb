class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.11.2-src/pyside-setup-everywhere-src-5.11.2.tar.xz"
  sha256 "18f572f1f832e476083d30fccabab167450f2a8cbe5cd9c6e6e4fa078ccb86c2"

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
