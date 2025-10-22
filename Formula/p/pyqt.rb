class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/f2/57/48985490c01584e00b70040ec0eb02dfe950471097201acb1b65deb633e5/pyqt6-6.10.0.tar.gz"
  sha256 "710ecfd720d9a03b2c684881ae37f528e11d17e8f1bf96431d00a6a73f308e36"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5713526fc5676369977ad488d6a2c38b1379a904089eb91ed207e78d167f5552"
    sha256 cellar: :any,                 arm64_sequoia: "833063eb751c9f567fc44419b8b9dd684f549bfd17cf1eb712f34fe99793e788"
    sha256 cellar: :any,                 arm64_sonoma:  "a3e3d4d23c601a5c934ea3716b279d08c087eb133db0fbcac08797cd3ba8bfa1"
    sha256 cellar: :any,                 sonoma:        "26409133a114e2bdd390d46d417bbec3d3431278accb45d078109576e7f06d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ecd65eba914578b6de62620a246926d98f2c51db9d1cc099ae89795b51043ab"
  end

  depends_on "pyqt-builder" => :build
  depends_on "python@3.14"
  depends_on "qt3d"
  depends_on "qtbase"
  depends_on "qtcharts"
  depends_on "qtconnectivity"
  depends_on "qtdatavis3d"
  depends_on "qtdeclarative"
  depends_on "qtmultimedia"
  depends_on "qtnetworkauth"
  depends_on "qtpositioning"
  depends_on "qtquick3d"
  depends_on "qtremoteobjects"
  depends_on "qtscxml"
  depends_on "qtsensors"
  depends_on "qtserialport"
  depends_on "qtspeech"
  depends_on "qtsvg"
  depends_on "qttools"
  depends_on "qtwebchannel"
  depends_on "qtwebsockets"

  on_macos do
    depends_on "qtshadertools"
  end

  on_system :linux, macos: :sonoma_or_newer do
    depends_on "qtwebengine"
  end

  # extra components
  resource "pyqt6-3d" do
    url "https://files.pythonhosted.org/packages/df/ca/2399911c654e0ff2c8f35043c6e240ab91b78557a53d7e4360e6ade5ec98/pyqt6_3d-6.10.0.tar.gz"
    sha256 "93d89fe30d98804b0983e9b52079d15ae82b1f0a279a5f90f2ff48ed3e6489ed"
  end

  resource "pyqt6-charts" do
    url "https://files.pythonhosted.org/packages/98/1d/ca03b2ebdf08a06780fea0ec2ca3bc1eeac0e68e59eb9f6ad95666b1e6aa/pyqt6_charts-6.10.0.tar.gz"
    sha256 "91e15e28d011caa4c83881a90687b35e3d05ef57290cdd9760824c95bdac6a3e"
  end

  resource "pyqt6-datavisualization" do
    url "https://files.pythonhosted.org/packages/a4/c6/ae606113706dbf4ca1f99e93e4a338595cb13f19996d17af810248155499/pyqt6_datavisualization-6.10.0.tar.gz"
    sha256 "4581c6f6f5e84f6431b01f563ef7b5036204a5f8823b0ea1ce5a083a880c4ee5"
  end

  resource "pyqt6-networkauth" do
    url "https://files.pythonhosted.org/packages/9b/a2/d9982657322efbfb4d3cfcbadfdb5c782ad19bcf54005bc6a730b156de01/pyqt6_networkauth-6.10.0.tar.gz"
    sha256 "94c9504613c8ff68f08eb1ff6ba7804c277b56e335baa6e44c1eba5279961f7b"
  end

  resource "pyqt6-sip" do
    url "https://files.pythonhosted.org/packages/2f/4a/96daf6c2e4f689faae9bd8cebb52754e76522c58a6af9b5ec86a2e8ec8b4/pyqt6_sip-13.10.2.tar.gz"
    sha256 "464ad156bf526500ce6bd05cac7a82280af6309974d816739b4a9a627156fafe"
  end

  resource "pyqt6-webengine" do
    url "https://files.pythonhosted.org/packages/8f/1a/9971af004a7e859347702f816fb71ecd67c3e32b2f0ae8daf1c1ded99f62/pyqt6_webengine-6.9.0.tar.gz"
    sha256 "6ae537e3bbda06b8e06535e4852297e0bc3b00543c47929541fcc9b11981aa25"
  end

  def python3
    "python3.14"
  end

  def install
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    sip_install = Formula["pyqt-builder"].opt_libexec/"bin/sip-install"
    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system sip_install, *args

    resource("pyqt6-sip").stage do
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end

    resources.each do |r|
      next if r.name == "pyqt6-sip"
      # Don't build WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
      next if r.name == "pyqt6-webengine" && OS.mac? && MacOS.version <= :ventura

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]", <<~TOML
          [tool.sip.project]
          sip-include-dirs = ["#{site_packages}/PyQt#{version.major}/bindings"]
        TOML
        system sip_install, "--target-dir", site_packages, "--verbose"
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
    pyqt_modules << "WebEngineCore" if OS.linux? || MacOS.version > :ventura
    pyqt_modules.each { |mod| system python3, "-c", "import PyQt#{version.major}.Qt#{mod}" }

    # Make sure plugin is installed as it currently gets skipped on wheel build,  e.g. `pip install`
    assert_path_exists share/"qt/plugins/designer"/shared_library("libpyqt#{version.major}")
  end
end
