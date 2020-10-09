class Pyqt < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/download5"
  url "https://files.pythonhosted.org/packages/1d/31/896dc3dfb6c81c70164019a6cbba6ab037e3af7653d9ca60ccc874ee4c27/PyQt5-5.15.1.tar.gz"
  sha256 "d9a76b850246d08da9863189ecb98f6c2aa9b4d97a3e85e29330a264aed0f9a1"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "ba91fe84fafeb809072d868fc831fa00fbf41b05f0f54d34ae4741a4dc6dbdb2" => :catalina
    sha256 "9f5af42de5df0fadbed7cd97440302643481edc0ef0c91c0aef3ef8702fd3030" => :mojave
    sha256 "4af6c3d6b8c2a874b5bfec4dfd530d43dffc45f20222bfaf1e7e9b94489a84c2" => :high_sierra
  end

  depends_on "python@3.9"
  depends_on "qt"
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
            "--qmake=#{Formula["qt"].bin}/qmake",
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
