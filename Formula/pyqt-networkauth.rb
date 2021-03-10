class PyqtNetworkauth < Formula
  desc "Python bindings for The Qt Company’s Qt Network Authorization library"
  homepage "https://www.riverbankcomputing.com/software/pyqtnetworkauth"
  url "https://files.pythonhosted.org/packages/56/7e/a400ce770ca83194cca6a129ca6e8339b2ec71b5dbe03fd8f1570be385e0/PyQt6_NetworkAuth-6.0.2.tar.gz"
  sha256 "ba3c55dc7ce7f4b9034f8675c5fe8d37830d986716ff2ef0cca29ee80240f609"
  license "GPL-3.0-only"

  depends_on "pyqt-builder" => :build

  depends_on "pyqt"
  depends_on "python@3.9"
  depends_on "qt"
  depends_on "sip"

  def install
    pyqt = Formula["pyqt"]
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"

    inreplace "pyproject.toml", "[tool.sip.project]", <<~EOS
      [tool.sip.project]
      sip-include-dirs = ["#{pyqt.opt_lib}/python#{xy}/site-packages/PyQt#{pyqt.version.major}/bindings"]
    EOS
    system "sip-install", "--target-dir", prefix
    (lib/"python#{xy}/site-packages").install %W[#{prefix}/PyQt#{pyqt.version.major} #{prefix}/PyQt#{pyqt.version.major}_NetworkAuth-#{version}.dist-info]
  end

  test do
    pyqt = Formula["pyqt"]
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{pyqt.version.major}.QtNetworkAuth"
  end
end
