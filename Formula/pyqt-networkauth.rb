class PyqtNetworkauth < Formula
  desc "Python bindings for The Qt Company’s Qt Network Authorization library"
  homepage "https://www.riverbankcomputing.com/software/pyqtnetworkauth"
  url "https://files.pythonhosted.org/packages/92/3d/3088bcf0bcba3b586c401dad60f7706224966e8861653088e5786115f66c/PyQt6_NetworkAuth-6.1.0.tar.gz"
  sha256 "11af1bb27a6b3686db8770cd9c089be408d4db93115ca77600e6c6415e3d318c"
  license "GPL-3.0-only"

  bottle do
    sha256 arm64_big_sur: "d198cfd91b4d84758fd496bdbd5b309c12f5f8951497faeee77d09899cb03ab4"
    sha256 big_sur:       "9b407dccafe9653a51d1498c08b1346cc5c0287b9e53cf98f67cd8d13c5612e7"
    sha256 catalina:      "b04e6105e03e14be91b363407cc7f7c882be07931c134cdac04ae537485f70b4"
    sha256 mojave:        "e769cc30eab94ba9f78d1f820103b55c5060a169ec03c7f13c28b3aa51bceded"
  end

  keg_only "pyqt now contains all submodules"
  disable! date: "2021-06-16", because: "pyqt now contains all submodules"

  depends_on "pyqt-builder" => :build
  depends_on "sip" => :build

  depends_on "pyqt"
  depends_on "python@3.9"
  depends_on "qt"

  def install
    pyqt = Formula["pyqt"]
    site_packages = Language::Python.site_packages("python3")

    inreplace "pyproject.toml", "[tool.sip.project]",
      "[tool.sip.project]\nsip-include-dirs = [\"#{pyqt.prefix/site_packages}/PyQt#{version.major}/bindings\"]\n"
    system "sip-install", "--target-dir", prefix/site_packages
  end

  test do
    pyqt = Formula["pyqt"]
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{pyqt.version.major}.QtNetworkAuth"
  end
end
