class Pyqt < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/download5"
  url "https://files.pythonhosted.org/packages/28/6c/640e3f5c734c296a7193079a86842a789edb7988dca39eab44579088a1d1/PyQt5-5.15.2.tar.gz"
  sha256 "372b08dc9321d1201e4690182697c5e7ffb2e0770e6b4a45519025134b12e4fc"
  license "GPL-3.0-only"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "167b4359448c02c360fb319a370ae27a002c2ad00430eb0ecf81b22f04714286" => :big_sur
    sha256 "8ccb745e9c567b384ca31f8e3f4b4943240d44b6c51e8e49b38073eb2fd7a835" => :arm64_big_sur
    sha256 "81c8c29e4a74e31ab9cfe8bcce524c991941f69861ab61fba073a42e24707218" => :catalina
    sha256 "25cb031596225a40027d02948692044d153a8f7d1e28102fb2b13db4146c7635" => :mojave
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
