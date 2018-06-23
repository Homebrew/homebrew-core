class Pyqt < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/download5"
  url "https://downloads.sourceforge.net/project/pyqt/PyQt5/PyQt-5.11/PyQt5_gpl-5.11.tar.gz"
  sha256 "46ebd9b23ef207fd0ebacae89efc8c967dbf84e2521a8e9858c5608cf47979ea"

  bottle do
    rebuild 1
    sha256 "6c25b7cb920e387426f82504152c8a4b914d8b42f92beed53f85832912c12034" => :high_sierra
    sha256 "9e75ec0a4bef6be7928db8fd3f8a1513d04aac1941226f133093a3494071701e" => :sierra
    sha256 "318c651ca9ff01dcd4c251a025eb89a105c560a5aaf1deb24b91bb08088d6ec2" => :el_capitan
  end

  option "with-debug", "Build with debug symbols"
  option "with-docs", "Install HTML documentation and python examples"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "qt"
  depends_on "sip"
  depends_on "python" => :recommended
  depends_on "python@2" => :recommended

  def install
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
