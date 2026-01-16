class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/96/03/e756f52e8b0d7bb5527baf8c46d59af0746391943bdb8655acba22ee4168/pyqt6-6.10.2.tar.gz"
  sha256 "6c0db5d8cbb9a3e7e2b5b51d0ff3f283121fa27b864db6d2f35b663c9be5cc83"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1da5eaaf94662961f84964b14d4bad63a997d1ee9a33bf1ca52cda6a97c83e2a"
    sha256 cellar: :any,                 arm64_sequoia: "decc8ae8a3b3e148bbf11b5a5ac4c1b711bc43768f699bb66fef94ba02f22348"
    sha256 cellar: :any,                 arm64_sonoma:  "f570a9802e539f69fc516a8e435bfad4c642d7826b3dc30c1b031ea87d192297"
    sha256 cellar: :any,                 sonoma:        "6fa5127fa04872e243f90c50a3a8524c5bb8b4bc28b190558139f337dc1df1a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2b2dbe475515323dfd19fdcc55ba4b05b5d8c7b5492960df04dd47d73ed902b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92efa396ff59ce6c73a2759b7693fef39941c012b0cf0b9146348c0a6d4f182b"
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

  on_sonoma :or_newer do
    depends_on "qtwebengine"
  end

  on_linux do
    # TODO: Add dependencies on all Linux when `qtwebengine` is bottled on arm64 Linux
    on_intel do
      depends_on "qtwebengine"
    end
  end

  pypi_packages exclude_packages: %w[pyqt6-3d-qt6 pyqt6-charts-qt6
                                     pyqt6-datavisualization-qt6 pyqt6-networkauth-qt6
                                     pyqt6-webengine-qt6 pyqt6-qt6],
                extra_packages:   %w[pyqt6-3d pyqt6-charts pyqt6-datavisualization
                                     pyqt6-networkauth pyqt6-webengine]

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
    url "https://files.pythonhosted.org/packages/0d/e9/d1b97154cec1d6c8a3d93fb6565d1463bc528fa5103491d626d07a451c7c/pyqt6_sip-13.10.3.tar.gz"
    sha256 "630895b3827e2c3b4e072089157985691fe4210d64340e71141f93775ea4ae51"
  end

  resource "pyqt6-webengine" do
    url "https://files.pythonhosted.org/packages/5f/5d/355dfe41246c611e861a1e88b43173b57c1b56a550bea12cfeaafbc7e6b6/pyqt6_webengine-6.10.0.tar.gz"
    sha256 "267d27275d0c79ae270bca4b03520a41fa7e85c2a4d9632da8cb9cc233a55ad1"
  end

  def python3
    "python3.14"
  end

  def webengine_supported?
    on_sonoma :or_newer do
      return true
    end
    on_linux do
      on_intel do
        return true
      end
    end
    false
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
