class Pyqt5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/download5"
  url "https://downloads.sourceforge.net/project/pyqt/PyQt5/PyQt-5.7.1/PyQt5_gpl-5.7.1.tar.gz"
  sha256 "be849f212a074049b9ebc10b6c07dddefb86e6d30e8df8a5c715cbb2cf7fad14"

  bottle do
    sha256 "00a65868fb96a2281e2af3e7739a773c75fc2d4a70b11aaf7693bd7ca8788e9f" => :sierra
    sha256 "b31d6639c1598c2b5466e5d66ae7157e4cfa50ea0a86853934264822e7ddf35d" => :el_capitan
    sha256 "0f86e5e31c9378e4fe02e9648811df717dd28831fa62c69f34866c539cfc94da" => :yosemite
  end

  option "with-debug", "Build with debug symbols"
  option "with-docs", "Install HTML documentation and python examples"

  deprecated_option "enable-debug" => "with-debug"

  depends_on :python3 => :recommended
  depends_on :python => :optional
  depends_on "qt5"

  if build.with? "python3"
    depends_on "sip" => "with-python3"
  else
    depends_on "sip"
  end

  def install
    if build.without?("python3") && build.without?("python")
      odie "pyqt5: --with-python3 must be specified when using --without-python"
    end

    Language::Python.each_python(build) do |python, version|
      args = ["--confirm-license",
              "--bindir=#{bin}",
              "--destdir=#{lib}/python#{version}/site-packages",
              "--stubsdir=#{lib}/python#{version}/site-packages/PyQt5",
              "--sipdir=#{share}/sip/Qt5",
              # sip.h could not be found automatically
              "--sip-incdir=#{Formula["sip"].opt_include}",
              # Make sure the qt5 version of qmake is found.
              # If qt4 is linked it will pickup that version otherwise.
              "--qmake=#{Formula["qt5"].bin}/qmake",
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
