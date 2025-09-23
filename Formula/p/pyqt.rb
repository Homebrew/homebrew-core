class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/32/1b/567f46eb43ca961efd38d7a0b73efb70d7342854f075fd919179fdb2a571/pyqt6-6.9.1.tar.gz"
  sha256 "50642be03fb40f1c2111a09a1f5a0f79813e039c15e78267e6faaf8a96c1c3a6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "713f37bc161900c3b7ee7cd678d38ad37736eed2e15b81dfcf359584df4bae6e"
    sha256 cellar: :any,                 arm64_ventura: "16e46160b7dc30711f7ca5cc70fffa7f1adb4dc8cb4ccd14b632a457b914d768"
    sha256 cellar: :any,                 sonoma:        "be7ad408bddb66cab773fe31d823a29efad50095d8f83e561e907bf06c5493c0"
    sha256 cellar: :any,                 ventura:       "5c1c607206fcb46100485f3f128bd6974cb26b251c20cde71fba1cfd104c41fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce5852c49a5ba65f576acc90970705cd4d55ddaa2d6ecad39caed9fe9222d6e5"
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
    url "https://files.pythonhosted.org/packages/2f/4a/96daf6c2e4f689faae9bd8cebb52754e76522c58a6af9b5ec86a2e8ec8b4/pyqt6_sip-13.10.2.tar.gz"
    sha256 "464ad156bf526500ce6bd05cac7a82280af6309974d816739b4a9a627156fafe"
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
