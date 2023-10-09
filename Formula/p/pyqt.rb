class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/34/da/e03b7264b1e88cd553ff62a71c0c19f55690e08928130f4aae613723e535/PyQt6-6.5.2.tar.gz"
  sha256 "1487ee7350f9ffb66d60ab4176519252c2b371762cbe8f8340fd951f63801280"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "afe285e05cf069bbd31e575742d1c42cd031de72879bb8645d9df3ece7c426b6"
    sha256 cellar: :any,                 arm64_ventura:  "d6235340f5b8bed96fcf1fc329b8469420dbf603cb708f177dccf412686aecbb"
    sha256 cellar: :any,                 arm64_monterey: "fb4b5563e49b887444c8d0c9d9ad7456e79956664dc81092245025075a10cadc"
    sha256 cellar: :any,                 arm64_big_sur:  "5136004db0464984b6a2cc37b4668f8558743a6a9df6b93fd5397ff44c3774f1"
    sha256 cellar: :any,                 sonoma:         "a3aadeedee462ca037ec98e03c31223f28187c8fa3eb221234fbf2b3959be3ec"
    sha256 cellar: :any,                 ventura:        "399b7e53bcfd275b0ea3699197e57f47cc6e4a435070358316effccccc61533b"
    sha256 cellar: :any,                 monterey:       "d761013b21ed972fdda44e2fc010801a6776bc7e25800bdaba96c8b92f368953"
    sha256 cellar: :any,                 big_sur:        "47d34d958146dedb529f4ecca90f8b9a63dabafa16378ae6cd406bbe4503bb90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ce996c6a606402baeba727decc8ff59aec06c962424ba6c3d80741735cd14a5"
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
    url "https://files.pythonhosted.org/packages/c0/08/6bde4b067729a7e0dac6b55654357a2a84af04f1152661cd1602979642a1/PyQt6_sip-13.5.2.tar.gz"
    sha256 "ebf6264b6feda01ba37d3b60a4bb87493bdb87be70f7b2a5384a7acd4902d88d"
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
