class PyqtAT5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/0e/07/c9ed0bd428df6f87183fca565a79fee19fa7c88c7f00a7f011ab4379e77a/PyQt5-5.15.11.tar.gz"
  sha256 "fda45743ebb4a27b4b1a51c6d8ef455c4c1b5d610c90d2934c7802b5c1557c52"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c644cc70170c656e7c4f6604b663a5af0f8bc1d09b095711cab7a920a397386"
    sha256 cellar: :any,                 arm64_sequoia: "7db6700257362834be48fdb3f21216c623062568dbee04ee726eaf1b38b98365"
    sha256 cellar: :any,                 arm64_sonoma:  "9b4dd05af3998cc273b6ad22754cdbca605889c291992bfea744d190e09d4d38"
    sha256 cellar: :any,                 sonoma:        "091e15df83f1e875c8994b8ba89393a30ab2ddc891f39c6c102475d0022164f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9febdc10fe92c98c76bd1cb3d58acdde779a65d6fbebc21c5bc0effed143b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97e6286b2b996eac230230c2d886f3f901ff77288881e488fada2124d13f6c6d"
  end

  deprecate! date: "2026-05-19", because: "is for end-of-life Qt 5"

  depends_on "pyqt-builder" => :build
  depends_on "python@3.14"
  depends_on "qt@5"

  pypi_packages exclude_packages: %w[pyqt5-qt5 pyqt3d-qt5 pyqtchart-qt5
                                     pyqtdatavisualization-qt5 pyqtnetworkauth-qt5
                                     pyqtpurchasing-qt5 pyqtwebengine-qt5],
                extra_packages:   %w[pyqt3d pyqtchart pyqtdatavisualization
                                     pyqtnetworkauth pyqtpurchasing pyqtwebengine]

  # extra components
  resource "pyqt3d" do
    url "https://files.pythonhosted.org/packages/ba/96/ab5686191cabca224dc0ecefedf8ff4c50c9e358ae3495f9a23a57068885/PyQt3D-5.15.7.tar.gz"
    sha256 "ea783eb546c7dad2d5eaaf82ea5050dde45255a9842e0a1d7584881e9e25a951"
  end

  resource "pyqt5-sip" do
    url "https://files.pythonhosted.org/packages/ea/08/88a20c862f40b5c178c517cdc7e93767967dec5ac1b994e226d517991c9b/pyqt5_sip-12.17.1.tar.gz"
    sha256 "0eab72bcb628f1926bf5b9ac51259d4fa18e8b2a81d199071135458f7d087ea8"
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
    "python3.14"
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
