class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/17/dc/969e2da415597b328e6a73dc233f9bb4f2b312889180e9bbe48470c957e7/PyQt6-6.6.0.tar.gz"
  sha256 "d41512d66044c2df9c5f515a56a922170d68a37b3406ffddc8b4adc57181b576"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e15e9c9d405c816f8dc9bd862a8ecc9dee4ba4f57b0882edaff11e4e74895d72"
    sha256 cellar: :any,                 arm64_ventura:  "52f349519b170e2bb4bac148a5d67ebd7b15efb1f9c25db603a9a7da179e9ba3"
    sha256 cellar: :any,                 arm64_monterey: "c4e06fddd93773e8af74597f333ac7f5aa4afd98f5d64ef29883c0789892edf6"
    sha256 cellar: :any,                 sonoma:         "eef2eb805bec8ce79597d38a8532e564b9a13d6875c3cf5de3711bb0dd2fab1f"
    sha256 cellar: :any,                 ventura:        "6a34516da70d5dd9d1e22416728d0c3b169dbb488272c55a16cc725ee3401120"
    sha256 cellar: :any,                 monterey:       "7d47fee83fb6bf7f4211beb50a6649fba62671eb6ed68fd0ddcbc6d67cf34bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b592d9a2083c87b232c4f4751a725610a3700ae0c42cc410201ba409951220d3"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip"          => :build

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
