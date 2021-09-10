class PyqtAT5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/8e/a4/d5e4bf99dd50134c88b95e926d7b81aad2473b47fde5e3e4eac2c69a8942/PyQt5-5.15.4.tar.gz"
  sha256 "2a69597e0dd11caabe75fae133feca66387819fc9bc050f547e5551bce97e5be"
  license "GPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "587a8a32bab96b5621d7a125c9d30816cc16af7b5bb5b1575324b5fb22ba5fc5"
    sha256 cellar: :any, big_sur:       "57e1fd479cc069392daab557c213607bcb45fae6494fce0898803be3696bb24b"
    sha256 cellar: :any, catalina:      "70bc904d9efee5ec5a2e6eec8d5cf7daf1d96790f13b41fa4027d42f62ebd6d4"
    sha256 cellar: :any, mojave:        "d824441486b767137fcad5620117299a7e3dd1423726a31c637cde4b1fcf2d39"
    sha256               x86_64_linux:  "7666898e0b34c8e2c204a9ee8a9d50c8daf0f8a82522d77a65e15d639468196f"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip"          => :build

  depends_on "python@3.9"
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # extra components
  resource "PyQt5-sip" do
    url "https://files.pythonhosted.org/packages/b1/40/dd8f081f04a12912b65417979bf2097def0af0f20c89083ada3670562ac5/PyQt5_sip-12.9.0.tar.gz"
    sha256 "d3e4489d7c2b0ece9d203ae66e573939f7f60d4d29e089c9f11daa17cfeaae32"
  end

  resource "3d" do
    url "https://files.pythonhosted.org/packages/c9/10/f90df77689e7bd11c42c21a6d5808cc08cf15aba971ad925605331c03bf8/PyQt3D-5.15.4.tar.gz"
    sha256 "36bc56d7432ab6c59ea77e1df6f6f688d8abd6cdb340706d5cb0a9c665e13975"
  end

  resource "chart" do
    url "https://files.pythonhosted.org/packages/e6/af/dd493297922be2935ae2de34daea818940c4f747a98d09acaaa5e84cd1dd/PyQtChart-5.15.4.tar.gz"
    sha256 "e47750632851e105eabc27fdfa8180989d120b822181e512f6643b3c5c4d8074"
  end

  resource "datavis" do
    url "https://files.pythonhosted.org/packages/b2/99/ffca927075ef4af724b4c294b3e95026bc15374e0d5f4ffa0abbab39abc3/PyQtDataVisualization-5.15.4.tar.gz"
    sha256 "fe5e00193994cccc67215d527884d5503d296ae93d928cf4f60f3748ad4d54fa"
  end

  resource "networkauth" do
    url "https://files.pythonhosted.org/packages/ca/8e/579511ad413768091cdfbbabd0e512dea37a9190e4551f391832a27d9702/PyQtNetworkAuth-5.15.4.tar.gz"
    sha256 "893b9f8afb26a64757e9fa3436261b8bfcb4e696efc2a364a9dc8ac44db67fa7"
  end

  resource "webengine" do
    url "https://files.pythonhosted.org/packages/fb/5d/4c5bb7adca4f2436545a391fe311dcb4ccc711f1ce2ab7adb87475ec566e/PyQtWebEngine-5.15.4.tar.gz"
    sha256 "cedc28f54165f4b8067652145aec7f732a17eadf6736835852868cf76119cc19"
  end

  resource "purchasing" do
    url "https://files.pythonhosted.org/packages/12/c5/bc1dc2dd3add23b12b61e9ed7c039a3f3b0bd1b8466dc69f26bdfa50af47/PyQtPurchasing-5.15.4.tar.gz"
    sha256 "b784a09f0a3adebd5c0d787fd8e139443f964dc44d81f801b7f6d1feb83cc4d5"
  end

  def install
    site_packages = prefix/Language::Python.site_packages("python3")
    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
      --no-designer-plugin
      --no-qml-plugin
    ]
    system "sip-install", *args

    resource("PyQt5-sip").stage do
      system "python3", *Language::Python.setup_install_args(prefix)
    end

    components = %w[3d chart datavis networkauth purchasing]
    components << "webengine" if OS.mac? && !Hardware::CPU.arm?
    components.each do |p|
      resource(p).stage do
        inreplace "pyproject.toml", "[tool.sip.project]",
          "[tool.sip.project]\nsip-include-dirs = [\"#{site_packages}/PyQt#{version.major}/bindings\"]\n"
        system "sip-install", "--target-dir", site_packages
      end
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
