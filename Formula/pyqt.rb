class Pyqt < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/download5"
  url "https://files.pythonhosted.org/packages/7c/5b/e760ec4f868cb77cee45b4554bf15d3fe6972176e89c4e3faac941213694/PyQt5-5.14.0.tar.gz"
  sha256 "0145a6b7de15756366decb736c349a0cb510d706c83fda5b8cd9e0557bc1da72"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c3e2354b324a380fee65658f87b22ec03bc3ac81538786d9148d0524de72cdac" => :catalina
    sha256 "3400e6944a13f80b02bbd44f634aadd6caee0c00012ab0170f922d00fe2e758b" => :mojave
    sha256 "7dbe8e7e69eeda102bae7cae9f6f1ccae9c73ea9662643df1534b66a9e8a70cc" => :high_sierra
  end

  depends_on "python"
  depends_on "qt"
  depends_on "sip"

  def install
    version = Language::Python.major_minor_version "python3"
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
            "--designer-plugindir=#{pkgshare}/plugins",
            "--qml-plugindir=#{pkgshare}/plugins",
            "--verbose"]

    system "python3", "configure.py", *args
    system "make"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    system "#{bin}/pyuic5", "--version"
    system "#{bin}/pylupdate5", "-version"

    system "python3", "-c", "import PyQt5"
    %w[
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      Widgets
      Xml
    ].each { |mod| system "python3", "-c", "import PyQt5.Qt#{mod}" }
  end
end
