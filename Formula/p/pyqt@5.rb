class PyqtAT5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/0e/07/c9ed0bd428df6f87183fca565a79fee19fa7c88c7f00a7f011ab4379e77a/PyQt5-5.15.11.tar.gz"
  sha256 "fda45743ebb4a27b4b1a51c6d8ef455c4c1b5d610c90d2934c7802b5c1557c52"
  license "GPL-3.0-only"
  revision 3
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0a5280ffc9e5ac25ad6088871564501c824f7d4bb62f36f55dbb43c8b972aa6c"
    sha256 cellar: :any, arm64_tahoe:       "1b044957bf70664e41eb77bf4486bfd416a53c5fff348964e60df09f51f76b54"
    sha256 cellar: :any, arm64_sequoia:     "3ef599ff47afa4f11570c7b6dc5b043e78d91c0ac9c419d8605f1c40b2a6a672"
    sha256 cellar: :any, arm64_linux:       "3d6f7e138086aa8a72a6e1d709724d8f248e268d9b4485e728bee26c29b4750b"
    sha256 cellar: :any, x86_64_linux:      "04ff33d9464d6ecf5e18010647b8a1cea8c95d850e5f47d3f848b18492e4511d"
  end

  deprecate! date: "2026-05-19", because: "is for end-of-life Qt 5"
  disable! date: "2027-05-19", because: "is for end-of-life Qt 5"

  depends_on "pyqt-builder" => :build
  depends_on "python@3.15"
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
    url "https://files.pythonhosted.org/packages/cd/ab/835df8e6fb06a618a4b8664765c5598e933c8113e90448e294549c9447f7/pyqt5_sip-12.20.0.tar.gz"
    sha256 "93e0622791f8d22cd4a32a29edfdd2ef6d6680f4c47f59b03ebf1c5da3c3e896"
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

  # Python 3.15 support, backported from upstream commit 3aa6092c44cd17a3afcd9f8ca879c4e40d2662d1
  patch do
    url "https://salsa.debian.org/python-team/packages/pyqt5/-/raw/1c7499d1d4d79737ae367ec263a9be71ce2b76ee/debian/patches/Support-for-Python-v3.15.patch"
    sha256 "14aa69d2e7e5cdbe9020eed753926f434a2f0569969236a1afd16e20ebf11fcd"
    type :unofficial
    resolves "https://bugs.debian.org/1144994"
  end

  def install
    sip_install = formula_opt_libexec("pyqt-builder")/"bin/sip-install"
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
