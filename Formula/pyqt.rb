class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/1c/77/3b14889ac1e677bd5a284e0d003cac873689046e328401d92a927c9cc921/PyQt6-6.5.1.tar.gz"
  sha256 "e166a0568c27bcc8db00271a5043936226690b6a4a74ce0a5caeb408040a97c3"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "94566b8f45b52301297ad339a025148912115007f936561f53ea07b47b214b5d"
    sha256 cellar: :any, arm64_monterey: "b60bcb667ce4871c40f6ff4ebcbca68395c9cad83578010e82ffd83faac56b8a"
    sha256 cellar: :any, arm64_big_sur:  "99047760264fac4d27c5addcf2c24a50997fe7f0dcaacea1f9109692921c389a"
    sha256 cellar: :any, ventura:        "e2b19888948037dc7e07db03de6e0a87776e21b3d5a73dbb0a6175451e80d83d"
    sha256 cellar: :any, monterey:       "c65b71dd6dd57ab952633cd56b8a4e21c470d6bd3a9445e6676899a2bfaf3fb5"
    sha256 cellar: :any, big_sur:        "56bdf19643876023f840c2247c151e66175e926ce54224b241b7aa3513bd07c6"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip"          => :build

  depends_on "python@3.11"
  depends_on "qt"

  fails_with gcc: "5"

  # extra components
  resource "pyqt6-3d" do
    url "https://files.pythonhosted.org/packages/61/3d/3c2fc89e929138d42face65a0ad2b81ad0f2df9701d8fd74ad591a2eaa28/PyQt6_3D-6.5.0.tar.gz"
    sha256 "f8ef3e2965a518367eb4cc693fd9f23698fcbeb909c7dcb7269737b8d877f68b"
  end

  resource "pyqt6-charts" do
    url "https://files.pythonhosted.org/packages/d7/da/aef92577bb1d0679cc4f47218c89e6875c5a3e515f32db33a738f95dac06/PyQt6_Charts-6.5.0.tar.gz"
    sha256 "6ff00f65b2517f99bf106ddd28c76f3ca344f91ecf5ba68191e20a2d90024962"
  end

  resource "pyqt6-datavisualization" do
    url "https://files.pythonhosted.org/packages/57/95/8086e46fdae5d5c8714e64c6c9f09c09e34eb85464199374ce1e39175174/PyQt6_DataVisualization-6.5.0.tar.gz"
    sha256 "19b949abcc315b1fa9293ba5b8b66bbf694d2d3f84585edc78167473328df212"
  end

  resource "pyqt6-networkauth" do
    url "https://files.pythonhosted.org/packages/dc/7f/2305cdafa48a14cf8f81a75f5d840277cf860cf4cec7afdb9d23d183ebe4/PyQt6_NetworkAuth-6.5.0.tar.gz"
    sha256 "7170db3f99e13aef855d9d52a00a8baa2dea92d12f9b441fed9c6dec57f83e09"
  end

  resource "pyqt6-sip" do
    url "https://files.pythonhosted.org/packages/2b/b4/87241bb21832cda1061805492ca2a5fd9d18969ea72277bb9fde94228962/PyQt6_sip-13.5.1.tar.gz"
    sha256 "d1e9141752966669576d04b37ba0b122abbc41cc9c35493751028d7d91c4dd49"
  end

  resource "pyqt6-webengine" do
    url "https://files.pythonhosted.org/packages/8d/dd/90d73f7b51f5bdc733341e317a9ac1f0d8fdf61d6c793061d429ae86e28f/PyQt6_WebEngine-6.5.0.tar.gz"
    sha256 "8ba9db56c4c181a2a2fab1673ca35e5b63dc69113f085027ddc43c710b6d6ee9"
  end

  def python3
    "python3.11"
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

    resource("pyqt6-sip").stage do
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end

    resources.each do |r|
      next if r.name == "pyqt6-sip"
      # Don't build WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
      next if r.name == "pyqt6-webengine" && OS.mac? && DevelopmentTools.clang_build_version <= 1200

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

    system python3, "-c", "import PyQt#{version.major}"
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
    pyqt_modules.each { |mod| system python3, "-c", "import PyQt#{version.major}.Qt#{mod}" }
  end
end
