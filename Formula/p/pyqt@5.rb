class PyqtAT5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/0e/07/c9ed0bd428df6f87183fca565a79fee19fa7c88c7f00a7f011ab4379e77a/PyQt5-5.15.11.tar.gz"
  sha256 "fda45743ebb4a27b4b1a51c6d8ef455c4c1b5d610c90d2934c7802b5c1557c52"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ee754605e872d1b42d4dafe9b53980d4917a49003f4b54c32d282fafbc2dbe25"
    sha256 cellar: :any,                 arm64_sonoma:  "4d1a259a2b1c7e926f1b84f60bf574348ce11d148e75ab7f47ca1f1310d696b2"
    sha256 cellar: :any,                 arm64_ventura: "3216d813b7409248232632126fdf3532a167a7796bc1e269440d8afae51d465e"
    sha256 cellar: :any,                 sonoma:        "a090e036da0b1d1dd57eedce4b51c5b0cc5032120b976cdaef3ceb57ae3d6eb5"
    sha256 cellar: :any,                 ventura:       "751f0e1bd98b6beae7643760f65ab8ae33a992010e5265fbddeb4c9c012b676b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f6a880862f2f69cc6fad70b2e6ca750bdfe8bb19ad41d41568cdeb4497d7278"
  end

  depends_on "pyqt-builder" => :build
  depends_on "python@3.13"
  depends_on "qt@5"

  # extra components
  resource "pyqt3d" do
    url "https://files.pythonhosted.org/packages/ba/96/ab5686191cabca224dc0ecefedf8ff4c50c9e358ae3495f9a23a57068885/PyQt3D-5.15.7.tar.gz"
    sha256 "ea783eb546c7dad2d5eaaf82ea5050dde45255a9842e0a1d7584881e9e25a951"
  end

  resource "pyqt5-sip" do
    url "https://files.pythonhosted.org/packages/01/79/086b50414bafa71df494398ad277d72e58229a3d1c1b1c766d12b14c2e6d/pyqt5_sip-12.17.0.tar.gz"
    sha256 "682dadcdbd2239af9fdc0c0628e2776b820e128bec88b49b8d692fe682f90b4f"
  end

  resource "pyqtchart" do
    url "https://files.pythonhosted.org/packages/f0/b9/c9548f0f5cab6640f4ea9e598a6a48e6d6a59ca23dad6004f90d25dc799a/PyQtChart-5.15.7.tar.gz"
    sha256 "bc9f1d26c725e820b0fff8db6e906e8b286128a14b3a98c59a0cd0c3d9924095"
  end

  resource "pyqtdatavisualization" do
    url "https://files.pythonhosted.org/packages/33/d5/0e531557035e4b51aecbf6f2a7e58c0539f4047e2b550af75f44d5c37e1e/PyQtDataVisualization-5.15.6.tar.gz"
    sha256 "9ed33b20e747bc69e1d619f147bb1625cc00d6ef404dbf076ba13a9ff6f6061d"
  end

  resource "pyqtnetworkauth" do
    url "https://files.pythonhosted.org/packages/59/44/927d519cd6f4ee1ec364c103205f16c2f8474df34b35a99ffc4a64d357ed/PyQtNetworkAuth-5.15.6.tar.gz"
    sha256 "85ada0c82b9787ffd614abff93bd6d9314d6528265f5f1d23a1922ef0cbeecb9"
  end

  resource "pyqtpurchasing" do
    url "https://files.pythonhosted.org/packages/68/cf/005c9e79536473c8354c1c2b59a2adcae8aa5b7269b42c06514490aa47fb/PyQtPurchasing-5.15.6.tar.gz"
    sha256 "304b1ea3bfb6555202751220700d9a98d1de9eab464515dfccca96f306ddf00e"
  end

  resource "pyqtwebengine" do
    url "https://files.pythonhosted.org/packages/18/e8/19a00646866e950307f8cd73841575cdb92800ae14837d5821bcbb91392c/PyQtWebEngine-5.15.7.tar.gz"
    sha256 "f121ac6e4a2f96ac289619bcfc37f64e68362f24a346553f5d6c42efa4228a4d"
  end

  def python3
    "python3.13"
  end

  def install
    sip_install = Formula["pyqt-builder"].opt_libexec/"bin/sip-install"
    site_packages = prefix/Language::Python.site_packages(python3)
    args = [
      "--target-dir", site_packages,
      "--scripts-dir", bin,
      "--confirm-license",
      "--no-designer-plugin",
      "--no-qml-plugin"
    ]
    system sip_install, *args

    resource("pyqt5-sip").stage do
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end

    resources.each do |r|
      next if r.name == "pyqt5-sip"

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]", <<~TOML
          [tool.sip.project]
          sip-include-dirs = ["#{site_packages}/PyQt#{version.major}/bindings"]
        TOML
        system sip_install, "--target-dir", site_packages
      end
    end
  end

  test do
    system bin/"pyuic#{version.major}", "--version"
    system bin/"pylupdate#{version.major}", "-version"

    components = %w[
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      WebEngineWidgets
      Widgets
      Xml
    ]

    system python3, "-c", "import PyQt#{version.major}"
    components.each { |mod| system python3, "-c", "import PyQt5.Qt#{mod}" }
  end
end
