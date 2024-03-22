class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/8c/2b/6fe0409501798abc780a70cab48c39599742ab5a8168e682107eaab78fca/PyQt6-6.6.1.tar.gz"
  sha256 "9f158aa29d205142c56f0f35d07784b8df0be28378d20a97bcda8bd64ffd0379"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ff17ae68092a601ba87f7b832338dd901211a835d27476080aa36446bd99b9bf"
    sha256 cellar: :any,                 arm64_ventura:  "3a96021b25dd3b62fbf3f13030803b1a9efb5915b89a1ea036840d52236017ab"
    sha256 cellar: :any,                 arm64_monterey: "83dd5e597599c9b9252a8af3b2c4cd1b7dcada2f98c74ad8595c76662bc4c927"
    sha256 cellar: :any,                 sonoma:         "b073875b968656e535ecbfe82d97c8e82df547dcd53fba0ed9505ff7a4f4f118"
    sha256 cellar: :any,                 ventura:        "c27efc9841aa96dd3d7e210af69ad5ed289ec14f3ac0acf094c3d41d36058ae3"
    sha256 cellar: :any,                 monterey:       "aec2292f8f4801700d2277fd7d6d2d8c440627a222e9218200edfdaf121ec261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65595d4529b06a6d1079f1671181b75b0df15b21255059798f69baba46ce2342"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip" => :build
  depends_on "python@3.12"
  depends_on "qt"

  fails_with gcc: "5"

  # extra components
  resource "pyqt6-3d" do
    url "https://files.pythonhosted.org/packages/3c/3f/7909d2886f500b9512a544c46c4e3e213a7624229a1dd1f417b885dedd6e/PyQt6_3D-6.6.0.tar.gz"
    sha256 "372b206eb8185f2b6ff048629d3296cb137c9e5901b113119ffa46a317726988"
  end

  resource "pyqt6-charts" do
    url "https://files.pythonhosted.org/packages/ef/7e/88d25f0c34a795744d8b87d0bdb5c76ce0e28f4070568e763442973c3e2c/PyQt6_Charts-6.6.0.tar.gz"
    sha256 "14cc6e5d19cae80129524a42fa6332d0d5dada4282a9423425e6b9ae1b6bc56d"
  end

  resource "pyqt6-datavisualization" do
    url "https://files.pythonhosted.org/packages/e1/ca/8b4a4ba040ecfa4fa0859ee8dcb99095f19c4ca5e42255821c9a6feafde8/PyQt6_DataVisualization-6.6.0.tar.gz"
    sha256 "5ad62a0f9815eca3acdff1078cfc2c10f6542c1d5cfe53626c0015e854441479"
  end

  resource "pyqt6-networkauth" do
    url "https://files.pythonhosted.org/packages/c4/db/b4a4ec7c0566b247410a0371a91050592b76480ca7581ebeb2c537f4596b/PyQt6_NetworkAuth-6.6.0.tar.gz"
    sha256 "cdfc0bfaea16a9e09f075bdafefb996aa9fdec392052ba4fb3cbac233c1958fb"
  end

  resource "pyqt6-sip" do
    url "https://files.pythonhosted.org/packages/98/23/e54e02a44afc357ccab1b88575b90729664164358ceffde43e4f2e549daa/PyQt6_sip-13.6.0.tar.gz"
    sha256 "2486e1588071943d4f6657ba09096dc9fffd2322ad2c30041e78ea3f037b5778"
  end

  resource "pyqt6-webengine" do
    url "https://files.pythonhosted.org/packages/49/9a/69db3a2ab1ba43f762144a66f0375540e195e107a1049d7263ab48ebc9cc/PyQt6_WebEngine-6.6.0.tar.gz"
    sha256 "d50b984c3f85e409e692b156132721522d4e8cf9b6c25e0cf927eea2dfb39487"
  end

  def python3
    "python3.12"
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
