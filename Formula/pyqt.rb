class Pyqt < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/download5"
  url "https://dl.bintray.com/homebrew/mirror/pyqt-5.10.1.tar.gz"
  mirror "https://downloads.sourceforge.net/project/pyqt/PyQt5/PyQt-5.10.1/PyQt5_gpl-5.10.1.tar.gz"
  sha256 "9932e971e825ece4ea08f84ad95017837fa8f3f29c6b0496985fa1093661e9ef"
  revision 2

  bottle do
    cellar :any
    rebuild 2
    sha256 "c941b19b803f11da31ec2cd93550a7b70b1ef919868890abf37b8d6d8e9dc089" => :mojave
    sha256 "cdbf71cc3b3c6b372787dc402f3c5ce48e17167d69349af7f8fd7fbd08b5286b" => :high_sierra
    sha256 "7f300676f7d52223129dc4e5080db09aa639ab5b92ca27a3424655ca438a0bf4" => :sierra
  end

  depends_on "python"
  depends_on "qt"
  depends_on "sip"

  # Patch from openSUSE for compatibility with Qt 5.11.0
  # https://build.opensuse.org/package/show/home:cgiboudeaux:branches:KDE:Qt5/python-qt5
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4f563668/pyqt/qt-5.11.diff"
    sha256 "34bba97f87615ea072312bfc03c4d3fb0a1cf7a4cd9d6907857c1dca6cc89200"
  end

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
            "--qml-plugindir=#{pkgshare}/plugins",
            "--verbose"]

    system "python3", "configure.py", *args
    system "make"
    system "make", "install"
    system "make", "clean"
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
      WebEngineWidgets
      Widgets
      Xml
    ].each { |mod| system "python3", "-c", "import PyQt5.Qt#{mod}" }
  end
end
