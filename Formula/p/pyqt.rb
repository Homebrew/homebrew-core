class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/8b/77/73ae0fd2ce7915ce87269743fd11f14f009b8db60a58759afc1c402327f2/pyqt6-6.12.0.tar.gz"
  sha256 "d3e021b716bae880224422f9d1b894d2d53de7e60e60dbc43f860723f9cc300b"
  license "GPL-3.0-only"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f975ee0c94a3fa4eaac19655ff7bb46fe1b598b000f84d2efb4fd722faf1c072"
    sha256 cellar: :any, arm64_tahoe:       "acfa6cdcdf77f26f2f6bd94f153a81f0112f8a2cab452e7ed078736871dd4da7"
    sha256 cellar: :any, arm64_sequoia:     "8cfb9c238b970be44f7b461b96e340f7413b8a6c35919e45a7231cf4f5d0a2cf"
    sha256 cellar: :any, arm64_linux:       "6dc1bfcb5d8212f73cd13aab856175c8bc310f6db98af1b28a2a71a6990a484f"
    sha256 cellar: :any, x86_64_linux:      "307388a644fc895cc62490e401d8b31edc1c1546c0b17635261fea182b46c2b9"
  end

  depends_on "pyqt-builder" => :build
  depends_on "python@3.15"
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
    url "https://files.pythonhosted.org/packages/fd/3f/6fbd34357734b7915b3a293582654c07be51dab553bcddf11d03446dbf53/pyqt6_3d-6.12.0.tar.gz"
    sha256 "be72460ed5e2429fc6e905fd0ff4cbc8431a56bc2d19d315ce792bfa1c0c838f"
  end

  resource "pyqt6-charts" do
    url "https://files.pythonhosted.org/packages/ae/ae/38466ca9f9da954c9dc72438e12bd671102cabb473b6dfc8382e92531f3a/pyqt6_charts-6.12.0.tar.gz"
    sha256 "856d0c8228fbdcff62bfeb9512f6c884965503c742ced9943f242bd5b67fdcec"
  end

  resource "pyqt6-datavisualization" do
    url "https://files.pythonhosted.org/packages/e0/c5/154b8896d79d55536ea39c55b08fd47be1e681d7fe23e14d1acd56ae78d0/pyqt6_datavisualization-6.12.0.tar.gz"
    sha256 "29052958ee5c4573ce11d484e05a3d13a25b19ae6bac67235b3a6e121253eed7"
  end

  resource "pyqt6-networkauth" do
    url "https://files.pythonhosted.org/packages/14/51/855ed92ce904ba430ad6f6cca9745957f785fb4391588cbd4b4537a5d594/pyqt6_networkauth-6.12.0.tar.gz"
    sha256 "e2c5fd09a8eb2a536199203ae97d7b42b9ae1578b3db20fd46e8c4f7ec117803"
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
