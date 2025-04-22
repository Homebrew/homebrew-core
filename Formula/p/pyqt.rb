class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/32/de/102e8e66149085acf38bbf01df572a2cd53259bcd99b7d8ecef0d6b36172/pyqt6-6.9.0.tar.gz"
  sha256 "6a8ff8e3cd18311bb7d937f7d741e787040ae7ff47ce751c28a94c5cddc1b4e6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "9d2e7040345f46c69227e5dd30def0a1c0476514d243e5b5dead7d41d56afa4c"
    sha256 cellar: :any,                 arm64_ventura: "d9ad0408c1b54060d3de9e2dd1f3e677a294e04731117826c53e3fa439acae4e"
    sha256 cellar: :any,                 sonoma:        "a32ce76f5d3bfe77347e5cbda5f8e03d078776ab79d2f727745ae6fc6816f562"
    sha256 cellar: :any,                 ventura:       "221fd42552d92677b357637d303cbe7f62f78ce3263dfb48051fbcbd0ae1189f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11224506e0d20f285ad01c36b366dda4e6b5b1723056f100c32935bf27a26fa9"
  end

  depends_on "pyqt-builder" => :build
  depends_on "python@3.13"
  depends_on "qt"

  # extra components
  resource "pyqt6-3d" do
    url "https://files.pythonhosted.org/packages/b3/1a/89e4bbc1c604d3a450111a7600d256b371200bf616157efd48c13f5646d3/pyqt6_3d-6.9.0.tar.gz"
    sha256 "af4b497e34f30e8dba53da2f2683e82994bc6d6f512fb7a91c3150aa31b6d49a"
  end

  resource "pyqt6-charts" do
    url "https://files.pythonhosted.org/packages/05/2e/d818e649751bd74df5aac3f8cfc7bc96c739ce19ae22fbaee75625a387e0/pyqt6_charts-6.9.0.tar.gz"
    sha256 "7efbe9bb7e6ad4f9845211a0efe0f91ca5e14f9362ed1ba84d55f2b8515091f7"
  end

  resource "pyqt6-datavisualization" do
    url "https://files.pythonhosted.org/packages/0e/64/2fb8f276b6231d9c7a4333279b39834fd05d9e503651db8e94c2c1980d3f/pyqt6_datavisualization-6.9.0.tar.gz"
    sha256 "1515475f1b2c37275ecf6ac74017a64fae8335d97b87fbbaf14bac3f82cdaa0a"
  end

  resource "pyqt6-networkauth" do
    url "https://files.pythonhosted.org/packages/88/6d/cc1fb6ae4fa7b455dbda92f8e41fefe6393a1081dfa2ebd9ddc7daf28ade/pyqt6_networkauth-6.9.0.tar.gz"
    sha256 "9acb6e97bd54584bbaeac2aabc40ec17a79d868f7da37a163c7bd4b7a8f04b09"
  end

  resource "pyqt6-sip" do
    url "https://files.pythonhosted.org/packages/90/18/0405c54acba0c8e276dd6f0601890e6e735198218d031a6646104870fe22/pyqt6_sip-13.10.0.tar.gz"
    sha256 "d6daa95a0bd315d9ec523b549e0ce97455f61ded65d5eafecd83ed2aa4ae5350"
  end

  resource "pyqt6-webengine" do
    url "https://files.pythonhosted.org/packages/8f/1a/9971af004a7e859347702f816fb71ecd67c3e32b2f0ae8daf1c1ded99f62/pyqt6_webengine-6.9.0.tar.gz"
    sha256 "6ae537e3bbda06b8e06535e4852297e0bc3b00543c47929541fcc9b11981aa25"
  end

  def python3
    "python3.13"
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
