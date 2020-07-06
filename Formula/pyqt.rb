class Pyqt < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/download5"
  url "https://files.pythonhosted.org/packages/8c/90/82c62bbbadcca98e8c6fa84f1a638de1ed1c89e85368241e9cc43fcbc320/PyQt5-5.15.0.tar.gz"
  sha256 "c6f75488ffd5365a65893bc64ea82a6957db126fbfe33654bcd43ae1c30c52f9"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "a17f79ba93b629d68857864a9b35130b4cd56c650f4c80226fb9c983d40ef199" => :catalina
    sha256 "6bc5f85f905eb25f9bfc9e23da8af4d23ba77745ace301fe4d3e8b93ad9a27b7" => :mojave
    sha256 "6a823bc3eedf914192f63d8d21d4fc66ee32399100cb9b79b044dfd60fa401bb" => :high_sierra
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
