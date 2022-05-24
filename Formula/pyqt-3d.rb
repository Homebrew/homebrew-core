class Pyqt3d < Formula
  desc "Python bindings for The Qt Company’s Qt 3D framework"
  homepage "https://www.riverbankcomputing.com/software/pyqt3d/"
  url "https://files.pythonhosted.org/packages/f7/06/6a2d193f36d2f115fcfaac6375f05737270bc8c133cd259a7a3431c38152/PyQt6_3D-6.1.0.tar.gz"
  sha256 "8f04ffa5d8ba983434b0b12a63d06e8efab671a0b2002cee761bbd0ef443513c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1ebc992cfbe773992ac78168d35a613188f2ef568e692d73a64b92f4fe783966"
    sha256 cellar: :any, big_sur:       "dbedfd03a8d1726ef7cd83d4e99134c5b4557b83f49da2fb6079c8375a2b636c"
    sha256 cellar: :any, catalina:      "b20343bc989fa856da1d932f69d81b4d20b3260340b43d6bc7a8ef6d7b6be44d"
    sha256 cellar: :any, mojave:        "5d341e8e1b620672694be46288700363c543324cbc93d1f7fa4cc13b66d17874"
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
    python = Formula["python@3.9"]
    %w[
      Animation
      Core
      Extras
      Input
      Logic
      Render
    ].each { |mod| system python.bin/"python3", "-c", "import PyQt#{pyqt.version.major}.Qt3D#{mod}" }
  end
end
