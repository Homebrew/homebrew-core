class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/a3/ab/c5989de70eceed91abf5f828d99817462ff75f41558e9f5a6f5213f0932c/PyQt6-6.3.1.tar.gz"
  sha256 "8cc6e21dbaf7047d1fc897e396ccd9710a12f2ef976563dad65f06017d2c9757"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "1d353ebaa13f7b69a0f5ada963fb649546724bf6484cb2481c80c59b2ac5e8f7"
    sha256 cellar: :any,                 arm64_big_sur:  "8791b6c0b67d26b15a1675441281d8a8bd90d30c893f1a6511dc7b3134934d05"
    sha256 cellar: :any,                 monterey:       "3f4fcce7d645358abd89aea1ebde223a7d7cdc62bb9630e1eab12641e32f1240"
    sha256 cellar: :any,                 big_sur:        "1596db56a15ec29e2abb03e740202d0383cea6a51312540b076cc4295323c69d"
    sha256 cellar: :any,                 catalina:       "701f551318501e8204d3355ec171d68d7a0d63b073b053499b12f8a38ac9678f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "305619541c09def3339ab18e4b354ad52aa11377479d4aad726ef37ad2d18c97"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip"          => :build

  depends_on "python@3.10"
  depends_on "qt"

  fails_with gcc: "5"

  # extra components
  resource "PyQt6-sip" do
    url "https://files.pythonhosted.org/packages/39/fc/f889254efda90418e367df28da9d14ac64ca19a9d93f44355d21ac562b0f/PyQt6_sip-13.4.0.tar.gz"
    sha256 "6d87a3ee5872d7511b76957d68a32109352caf3b7a42a01d9ee20032b350d979"
  end

  resource "PyQt6-3D" do
    url "https://files.pythonhosted.org/packages/79/bc/5e2c0919b787eb59346a13b0938ec00ea2223c4b7b882af44f31b8242e55/PyQt6_3D-6.3.0.tar.gz"
    sha256 "fab024b7fb3245d9b463029e0000f46cff95f0bdab603b875fabcaa53d9fe63f"
  end

  resource "PyQt6-Charts" do
    url "https://files.pythonhosted.org/packages/b9/f7/669fdd84d0bbd18f1a3c01dff3bcdd12f866d01fa212cf05f2ffc06f5efb/PyQt6_Charts-6.3.1.tar.gz"
    sha256 "e6bbb17a3d5503508cb28a7b8f44dfedd659c43ff62adb64182a004fbd968f2f"
  end

  resource "PyQt6-DataVisualization" do
    url "https://files.pythonhosted.org/packages/6e/4d/281a11a6b2147167014285142d8dbfba8f8ac8d4de3dc8c8e7c66d152dbb/PyQt6_DataVisualization-6.3.1.tar.gz"
    sha256 "7509f24a84f92d127e17129ec18cb208f96bd3d12a0e4b6f57d57e955527ec34"
  end

  resource "PyQt6-NetworkAuth" do
    url "https://files.pythonhosted.org/packages/3c/75/64bd1f9c9ff50f28e3b5e6938d10b82ee10f9669c1e140ad08b9aec8e7a9/PyQt6_NetworkAuth-6.3.0.tar.gz"
    sha256 "b1434b349e0820649341accf78689e9efd2c73543ed7d5474f660aaea2708454"
  end

  resource "PyQt6-WebEngine" do
    url "https://files.pythonhosted.org/packages/90/99/59acbe75fb0ad284945d27e40f68c642850c7a186bfc9cc338c3f638d0dc/PyQt6_WebEngine-6.3.1.tar.gz"
    sha256 "c3d1f5527b4b15f44102d617c59b1d74d9af50f821629e9335f13df47de8f007"
  end

  def python3
    "python3.10"
  end

  def install
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system "sip-install", *args

    resource("PyQt6-sip").stage do
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end

    resources.each do |r|
      next if r.name == "PyQt6-sip"
      # Don't build WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
      next if r.name == "PyQt6-WebEngine" && OS.mac? && DevelopmentTools.clang_build_version <= 1200

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]",
          "[tool.sip.project]\nsip-include-dirs = [\"#{site_packages}/PyQt#{version.major}/bindings\"]\n"
        system "sip-install", "--target-dir", site_packages
      end
    end
  end

  test do
    system bin/"pyuic#{version.major}", "-V"
    system bin/"pylupdate#{version.major}", "-V"

    system Formula["python@3.10"].opt_bin/python3, "-c", "import PyQt#{version.major}"
    pyqt_modules = %w[
      3DAnimation
      3DCore
      3DExtras
      3DInput
      3DLogic
      3DRender
      Gui
      Multimedia
      Network
      NetworkAuth
      Positioning
      Quick
      Svg
      Widgets
      Xml
    ]
    # Don't test WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
    pyqt_modules << "WebEngineCore" if OS.linux? || DevelopmentTools.clang_build_version > 1200
    pyqt_modules.each { |mod| system Formula["python@3.10"].opt_bin/python3, "-c", "import PyQt#{version.major}.Qt#{mod}" }
  end
end
