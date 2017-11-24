class Pyqt < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/download5"
  url "https://downloads.sourceforge.net/project/pyqt/PyQt5/PyQt-5.9.2/PyQt5_gpl-5.9.2.tar.gz"
  sha256 "c190dac598c97b0113ca5e7a37c71c623f02d1d713088addfacac4acfa4b8394"

  bottle do
    sha256 "d5ba0557b5e149aa91c3ca34fdfcb059372043c74b9181ce7ffc8841e07dc77c" => :high_sierra
    sha256 "2b11d3f51db55fd462f3db1924d4996629233533b14d33170cada601c089bd66" => :sierra
    sha256 "3e1a7f6d3ae58e97655604296df625eaa475245a8ac3c0d0b3d1ef4463b5cca9" => :el_capitan
  end

  option "with-debug", "Build with debug symbols"
  option "with-docs", "Install HTML documentation and python examples"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "qt"
  depends_on "sip"
  depends_on :python => :recommended
  depends_on :python3 => :recommended

  def install
    if build.without?("python3") && build.without?("python")
      odie "pyqt: --with-python3 must be specified when using --without-python"
    end

    Language::Python.each_python(build) do |python, version|
      args = ["--confirm-license",
              "--bindir=#{bin}",
              "--destdir=#{lib}/python#{version}/site-packages",
              "--stubsdir=#{lib}/python#{version}/site-packages/PyQt5",
              "--sipdir=#{share}/sip/Qt5",
              # sip.h could not be found automatically
              "--sip-incdir=#{Formula["sip"].opt_include}",
              "--qmake=#{Formula["qt"].bin}/qmake",
              # Force deployment target to avoid libc++ issues
              "QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
              "--qml-plugindir=#{pkgshare}/plugins",
              "--verbose"]
      args << "--debug" if build.with? "debug"

      system python, "configure.py", *args
      system "make"
      system "make", "install"
      system "make", "clean"
    end
    doc.install "doc/html", "examples" if build.with? "docs"
  end

  test do
    system "#{bin}/pyuic5", "--version"
    system "#{bin}/pylupdate5", "-version"
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "import PyQt5"
      %w[
        Gui
        Location
        Multimedia
        Network
        Quick
        Svg
        WebEngineWidgets
        Widgets
        Xml
      ].each { |mod| system python, "-c", "import PyQt5.Qt#{mod}" }
    end
  end
end
