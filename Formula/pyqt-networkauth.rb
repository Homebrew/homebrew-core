class PyqtNetworkauth < Formula
  desc "Python bindings for The Qt Company’s Qt Network Authorization library"
  homepage "https://www.riverbankcomputing.com/software/pyqtnetworkauth"
  url "https://files.pythonhosted.org/packages/21/de/a7c4ef992a66be7ee458ab25ad7cdf93483712517ba807a74c30dc7c9375/PyQt6_NetworkAuth-6.0.3.tar.gz"
  sha256 "ae3c1540e9504eea024ee4da13c6ead146f987aa5fe1942c8d7465ef631e8ba8"
  license "GPL-3.0-only"

  bottle do
    sha256 arm64_big_sur: "d198cfd91b4d84758fd496bdbd5b309c12f5f8951497faeee77d09899cb03ab4"
    sha256 big_sur:       "9b407dccafe9653a51d1498c08b1346cc5c0287b9e53cf98f67cd8d13c5612e7"
    sha256 catalina:      "b04e6105e03e14be91b363407cc7f7c882be07931c134cdac04ae537485f70b4"
    sha256 mojave:        "e769cc30eab94ba9f78d1f820103b55c5060a169ec03c7f13c28b3aa51bceded"
  end

  depends_on "pyqt-builder" => :build

  depends_on "pyqt"
  depends_on "python@3.9"
  depends_on "qt"
  depends_on "sip"

  def install
    pyqt = Formula["pyqt"]
    python = Formula["python@3.9"]
    site_packages = Language::Python.site_packages(python)

    open("pyproject.toml", "a") do |f|
      f.puts "[tool.sip.project]"
      f.puts "sip-include-dirs = [\"#{pyqt.prefix/site_packages}/PyQt#{pyqt.version.major}/bindings\"]"
    end

    system "sip-install", "--target-dir", prefix/site_packages
  end

  test do
    pyqt = Formula["pyqt"]
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{pyqt.version.major}.QtNetworkAuth"
  end
end
