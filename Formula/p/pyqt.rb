class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/61/5f/39d2cf3eabc36006a5c87df6e1ed34928025b4a1768d752859bf404ec341/pyqt6-6.12.1.tar.gz"
  sha256 "17bb18b3ae953ab54b23026291ecea2579b028597b56c281a752c8ed66dd1a58"
  license "GPL-3.0-only"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ebbaf635f04ee0d982073b74ff93df0ec66c70c2609226b2bdf93f99a0c5b474"
    sha256 cellar: :any, arm64_tahoe:       "26c1908f1bbc5e0cb6aa641cead0e037ee011a6cd0836714548457a41bb6a8ba"
    sha256 cellar: :any, arm64_sequoia:     "206b7eb0aebd7ce610639f90ead792a61eafe5cbaeef2dd88edba3aa52a4ef5d"
    sha256 cellar: :any, arm64_linux:       "6f0c03d219e25d4c8937782d5c20ff8fbd49df53fd116c8fafb4905f382f29a5"
    sha256 cellar: :any, x86_64_linux:      "3a8a12c3798999423437b685dce3114c0bfcc3f6441117b91b3f9710ef355763"
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
    url "https://files.pythonhosted.org/packages/2a/5a/019661ce285b1c8c77475d8032d58e5a4fc02e6768a4b1a77a1bb023e6b1/pyqt6_3d-6.12.1.tar.gz"
    sha256 "a108137f846cad90a3cc8ffd0908e73aa3eefc08f3ad0e257391799bbce1fa88"
  end

  resource "pyqt6-charts" do
    url "https://files.pythonhosted.org/packages/91/69/be4c6ac8bc3e0d6700535291623ec846ef8c2f13710b22cd75bd9a3fe0a3/pyqt6_charts-6.12.1.tar.gz"
    sha256 "ec36de59ef4806d6140ed2f7670c8d769f8cedf88bbcda911753c3accae05216"
  end

  resource "pyqt6-datavisualization" do
    url "https://files.pythonhosted.org/packages/b0/97/45736d791c3b6607fd061018a3d59b7889f1b4454becf2f7aa6a1389dee5/pyqt6_datavisualization-6.12.1.tar.gz"
    sha256 "7f8d449ed9877081f636cc4c4e4c15554c8a08bccd00e47e85c5da3524ca0f00"
  end

  resource "pyqt6-networkauth" do
    url "https://files.pythonhosted.org/packages/f1/72/7aa765a7013c7e2c230b2d49d2364dedadf3fb86cc9f2480fd2e764c0d33/pyqt6_networkauth-6.12.1.tar.gz"
    sha256 "a96a227f933a80ef02c5ac029b3955d1f01c3a222059d4390d32e96aa6200262"
  end

  resource "pyqt6-sip" do
    url "https://files.pythonhosted.org/packages/03/da/164fe6759acbd04c4523a9471c4d11f4b3c744182cb7bbd87faf249ce172/pyqt6_sip-13.13.1.tar.gz"
    sha256 "83c3c9cb93b6c631af7048084fb0f234b610a01edbf9b2b44c4ee4bda4197efe"
  end

  resource "pyqt6-webengine" do
    url "https://files.pythonhosted.org/packages/9b/e3/f527f46fdbdaac9c3e4947e7426552f16ad0a1f53b1417176198b296c72c/pyqt6_webengine-6.140.1.tar.gz"
    sha256 "7e8b228d2f35806b50135b8fdc7572f3deea09263d2fe878d2fcae8c47c30f72"
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
