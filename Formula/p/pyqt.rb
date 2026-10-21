class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/8b/47/b25c13eca5bebc6505394d0223e46d7ebf0c57dcac2ed908d7d19b18ab6b/pyqt6-6.11.0.tar.gz"
  sha256 "45dd60aa69976de1918b5ced6b4e7b6a25abd2a919ecef5fd5826ecc76718889"
  license "GPL-3.0-only"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b90072e0f89ccd03c6753579645a6c335430ad83a3c4ea9f7d4c1d525ff97739"
    sha256 cellar: :any, arm64_tahoe:       "d6b6d541314cd529c74db23573ecc353503a7a0c3fe3e72beec93f4b901cd0e4"
    sha256 cellar: :any, arm64_sequoia:     "b36b1bb3ec6fd9f2b4828aea7455a87718df0522bae2e15fde12490f95e40d5f"
    sha256 cellar: :any, arm64_linux:       "27c2fc0a0ccbe2b9e0aa96bdac8e296d48aa3e3ece841dffcd3cba99096e837a"
    sha256 cellar: :any, x86_64_linux:      "7b3319a34dc736771a594819fc87ea6a3cb099690976a30b03ca6ce64215f5f1"
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

  pypi_packages exclude_packages: %w[pyqt6-3d-qt6 pyqt6-charts-qt6
                                     pyqt6-datavisualization-qt6 pyqt6-networkauth-qt6
                                     pyqt6-webengine-qt6 pyqt6-qt6],
                extra_packages:   %w[pyqt6-3d pyqt6-charts pyqt6-datavisualization
                                     pyqt6-networkauth pyqt6-webengine]

  # extra components
  resource "pyqt6-3d" do
    url "https://files.pythonhosted.org/packages/32/5e/7ef5875f6db3afd14c1bb56b4da9475ce779c7d6dc6c8d31a0456de31948/pyqt6_3d-6.11.0.tar.gz"
    sha256 "7d5467b42b31d3c7b9651009852a084b3feace904b0d89a63a23ae4bc6f74021"
  end

  resource "pyqt6-charts" do
    url "https://files.pythonhosted.org/packages/c0/7f/2bd22df06ba836b6a76ec193a8085dab4a666e320326e41bccc7b2695882/pyqt6_charts-6.11.0.tar.gz"
    sha256 "1091cd919806a3ce05d2276729f79be4ecbd0a939500a8899026c3ef5769c650"
  end

  resource "pyqt6-datavisualization" do
    url "https://files.pythonhosted.org/packages/94/57/31b188c1b47663784e2863cc8765a4e26f7efc16fa40eed76098952e10bb/pyqt6_datavisualization-6.11.0.tar.gz"
    sha256 "866f2f77ce162d296fc6957de30b59476190e8505dfdb42b77288d14e60086ee"
  end

  resource "pyqt6-networkauth" do
    url "https://files.pythonhosted.org/packages/55/86/14660569d6871477b8ea12138ea44dc12efc3ceaaee814215325e42d0d9f/pyqt6_networkauth-6.11.0.tar.gz"
    sha256 "03650f0b0d709284f4ede3b31170d78b996864406bf34a4a0e76474b9144ed2a"
  end

  resource "pyqt6-sip" do
    url "https://files.pythonhosted.org/packages/78/35/bed43ff7cf040ced6b62a17b272abecb94914755284b54e8d06844e1ed23/pyqt6_sip-13.13.0.tar.gz"
    sha256 "2cd55f575cde208c398d6cfdecc5a13394ed2afb54226210c50e3a6df7c3a997"
  end

  resource "pyqt6-webengine" do
    url "https://files.pythonhosted.org/packages/9a/c6/b4f777c46ff42a759180dc65ad49a207748ea2e83ac4df21e89eaf4834c3/pyqt6_webengine-6.11.0.tar.gz"
    sha256 "15cf49efbbbd4c6bc87653b2c4ae80d6049f800e31620b336734ae2e37cbedae"
  end

  def webengine_supported?
    on_sonoma :or_newer do
      return true
    end
    on_linux do
      return true
    end
    false
  end

  def install
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    sip_install = formula_opt_libexec("pyqt-builder")/"bin/sip-install"
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
      next if r.name == "pyqt6-webengine" && !webengine_supported?

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
    pyqt_modules << "WebEngineCore" if webengine_supported?
    pyqt_modules.each { |mod| system python3, "-c", "import PyQt#{version.major}.Qt#{mod}" }

    # Make sure plugin is installed as it currently gets skipped on wheel build,  e.g. `pip install`
    assert_path_exists share/"qt/plugins/designer"/shared_library("libpyqt#{version.major}")
  end
end
