class Pyqt < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/download5"
  url "https://downloads.sourceforge.net/project/pyqt/PyQt5/PyQt-5.9/PyQt5_gpl-5.9.tar.gz"
  sha256 "ab0e7999cf202cc72962c78aefe461d16497b3c1a8282ab966ad90b6cb271096"
  revision 1

  bottle do
    sha256 "188c589ce78ba9d7f0f21ed9f9c8f5e24756f5a940000cd8eb154dc2e5924bfd" => :sierra
    sha256 "6d8ebe1577d3a2305359a04825894447ec97804025ed348ae69f1f218a157bf5" => :el_capitan
    sha256 "cf3a5cc5dcd8c5f1c04abe798be9c3c5e12c4cfe234335f79fa89647328dfa32" => :yosemite
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
