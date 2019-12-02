class Pyqt < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/download5"
  url "https://files.pythonhosted.org/packages/7c/5b/e760ec4f868cb77cee45b4554bf15d3fe6972176e89c4e3faac941213694/PyQt5-5.14.0.tar.gz"
  sha256 "0145a6b7de15756366decb736c349a0cb510d706c83fda5b8cd9e0557bc1da72"
  revision 1

  bottle do
    cellar :any
    sha256 "e2abbfd19a3b2e9c52f2c1c4fb84cc752f832b616a89c1138ab74cad96d95584" => :catalina
    sha256 "5026dd96d99bb8866d2a2b3bf1bc55d66f9ddbd39e9180ee7c921481b49f39b9" => :mojave
    sha256 "32f1de6e98558bbf79e31771cfa6bce4206bac12108f384324006c1a18209dfc" => :high_sierra
  end

  depends_on "python@3.8"
  depends_on "qt"
  depends_on "sip"

  def install
    version = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
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
            "--pyuic5-interpreter=#{Formula["python@3.8"].opt_bin}/python3",
            "--verbose"]

    system Formula["python@3.8"].opt_bin/"python3", "configure.py", *args
    system "make"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    system "#{bin}/pyuic5", "--version"
    system "#{bin}/pylupdate5", "-version"

    system Formula["python@3.8"].opt_bin/"python3", "-c", "import PyQt5"
    %w[
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      Widgets
      Xml
    ].each { |mod| system Formula["python@3.8"].opt_bin/"python3", "-c", "import PyQt5.Qt#{mod}" }
  end
end
