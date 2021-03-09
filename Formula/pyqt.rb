class Pyqt < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/download5"
  url "https://files.pythonhosted.org/packages/28/6c/640e3f5c734c296a7193079a86842a789edb7988dca39eab44579088a1d1/PyQt5-5.15.2.tar.gz"
  sha256 "372b08dc9321d1201e4690182697c5e7ffb2e0770e6b4a45519025134b12e4fc"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "62dd04f103f14e2e1eaddf86a910150010272f3dbc65ccdc0f8a46b5c42838fb"
    sha256 cellar: :any, big_sur:       "47f7747c0bb57baf7be2c90f0c7abd9382cb1a0caf3d0554ab6935a933962ff4"
    sha256 cellar: :any, catalina:      "ad56d5b20ed4f896ae9295e5ddf6e4b3feba9abf462fec8b584fa162a1988d78"
    sha256 cellar: :any, mojave:        "0ad16dcf14f820bb1ecbd96974264d04f9c58ee8f8068cd7f47de88b275d8c1e"
  end

  depends_on "python@3.9"
  depends_on "qt@5"
  depends_on "sip"

  resource "PyQt5-sip" do
    url "https://files.pythonhosted.org/packages/73/8c/c662b7ebc4b2407d8679da68e11c2a2eb275f5f2242a92610f6e5024c1f2/PyQt5_sip-12.8.1.tar.gz"
    sha256 "30e944db9abee9cc757aea16906d4198129558533eb7fadbe48c5da2bd18e0bd"
  end

  def install
    version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    args = ["--confirm-license",
            "--bindir=#{bin}",
            "--destdir=#{lib}/python#{version}/site-packages",
            "--stubsdir=#{lib}/python#{version}/site-packages/PyQt5",
            "--sipdir=#{share}/sip/Qt5",
            # sip.h could not be found automatically
            "--sip-incdir=#{Formula["sip"].opt_include}",
            "--qmake=#{Formula["qt@5"].bin}/qmake",
            # Force deployment target to avoid libc++ issues
            "QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
            "--designer-plugindir=#{pkgshare}/plugins",
            "--qml-plugindir=#{pkgshare}/plugins",
            "--pyuic5-interpreter=#{Formula["python@3.9"].opt_bin}/python3",
            "--verbose"]

    system Formula["python@3.9"].opt_bin/"python3", "configure.py", *args
    system "make"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    system "#{bin}/pyuic5", "--version"
    system "#{bin}/pylupdate5", "-version"

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt5"
    %w[
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      Widgets
      Xml
    ].each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt5.Qt#{mod}" }
  end
end
