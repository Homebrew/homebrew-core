class PyqtNetworkauth < Formula
  desc "Python bindings for The Qt Company’s Qt Network Authorization library"
  homepage "https://www.riverbankcomputing.com/software/pyqtnetworkauth"
  url "https://files.pythonhosted.org/packages/92/3d/3088bcf0bcba3b586c401dad60f7706224966e8861653088e5786115f66c/PyQt6_NetworkAuth-6.1.0.tar.gz"
  sha256 "11af1bb27a6b3686db8770cd9c089be408d4db93115ca77600e6c6415e3d318c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0d988ef8d9814b9c2b3ec956b9826eec3ed2cf4928374d99fb8b5fee9023a2fc"
    sha256 cellar: :any, big_sur:       "73396cbd45e61c6792ec73ffac9a8fb53b5917f008368a655b0b407ebca8447b"
    sha256 cellar: :any, catalina:      "de12b27c4e572f42701bae3f6914dd9175cb72bdbf96a1d79b555ad8440356d1"
    sha256 cellar: :any, mojave:        "21d8a3a2fe01a7442ae08adbbe6cc4e8cc396d7402a22932f3e751cda60926eb"
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
