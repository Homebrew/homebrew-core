class PyqtAT5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/8e/a4/d5e4bf99dd50134c88b95e926d7b81aad2473b47fde5e3e4eac2c69a8942/PyQt5-5.15.4.tar.gz"
  sha256 "2a69597e0dd11caabe75fae133feca66387819fc9bc050f547e5551bce97e5be"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "def5e1c4db90419439be7ac44ff3d11e6042590e3ef2e2f0586db5870b1b68fb"
    sha256 cellar: :any, big_sur:       "4346a1891f5a34b2a1b6e426609e44c05f1b892de539ac5eadf0d0deff5e93d1"
    sha256 cellar: :any, catalina:      "04e2f9b7627b65824026e005a4471d5179ec869d92ee87456e2afdeeead18a1d"
    sha256 cellar: :any, mojave:        "e0e324b2b9cca6dff32fa0cf68b353b3a2a85957ef8c8a0fb686f8f6cbcdffc1"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip" => :build

  depends_on "python@3.9"
  depends_on "qt@5"

  resource "PyQt5-sip" do
    url "https://files.pythonhosted.org/packages/73/8c/c662b7ebc4b2407d8679da68e11c2a2eb275f5f2242a92610f6e5024c1f2/PyQt5_sip-12.8.1.tar.gz"
    sha256 "30e944db9abee9cc757aea16906d4198129558533eb7fadbe48c5da2bd18e0bd"
  end

  def install
    python = Formula["python@3.9"]
    site_packages = prefix/Language::Python.site_packages(python)

    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
      --no-designer-plugin
      --no-qml-plugin
    ]
    system "sip-install", *args

    resource("PyQt5-sip").stage do
      system python.bin/"python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    system bin/"pyuic#{version.major}", "--version"
    system bin/"pylupdate#{version.major}", "-version"

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{version.major}"
    %w[
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      Widgets
      Xml
    ].each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt5.Qt#{mod}" }
  end
end
