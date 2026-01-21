class PyqtAT5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/0e/07/c9ed0bd428df6f87183fca565a79fee19fa7c88c7f00a7f011ab4379e77a/PyQt5-5.15.11.tar.gz"
  sha256 "fda45743ebb4a27b4b1a51c6d8ef455c4c1b5d610c90d2934c7802b5c1557c52"
  license "GPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d3944d21d80b85aadc871416d4072fad865a21b7d19c213bcced248534c1c1c2"
    sha256 cellar: :any,                 arm64_sequoia: "b92c0343b0fe78cd9d028e0b8c8d3ba566b044482415cef4f359df8b6c2b3ae2"
    sha256 cellar: :any,                 arm64_sonoma:  "b04e80d2ce51fbd1700e73cb12b733554a994cf297718b2b985f205de92aa377"
    sha256 cellar: :any,                 sonoma:        "9071ce79a740aaf8fad54d9f28796bc76a1a81342a377df0c143647155f09eb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92f0b1de8c364103ad2bdca8a22f6b786960d0f3df2ca86ec981ad8908bc0f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cba9e3e411e7161d02642f0bf4cd4254d03b180a5c108f184d45e346b9c7c123"
  end

  deprecate! date: "2026-05-19", because: "is for end-of-life Qt 5"

  depends_on "pyqt-builder" => :build
  depends_on "python@3.14"
  depends_on "qt@5"

  pypi_packages exclude_packages: %w[pyqt5-qt5 pyqt3d-qt5 pyqtchart-qt5
                                     pyqtdatavisualization-qt5 pyqtnetworkauth-qt5
                                     pyqtpurchasing-qt5],
                extra_packages:   %w[pyqt3d pyqtchart pyqtdatavisualization
                                     pyqtnetworkauth pyqtpurchasing]

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
      Widgets
      Xml
    ]

    system python3, "-c", "import PyQt#{version.major}"
    components.each { |mod| system python3, "-c", "import PyQt5.Qt#{mod}" }
  end
end
