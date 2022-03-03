class PyqtAT5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/3b/27/fd81188a35f37be9b3b4c2db1654d9439d1418823916fe702ac3658c9c41/PyQt5-5.15.6.tar.gz"
  sha256 "80343bcab95ffba619f2ed2467fd828ffeb0a251ad7225be5fc06dcc333af452"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_monterey: "05305ba5d0bc3ed5289b64e8df3ed20c1ccda93d61575ee00a403783287ee2e0"
    sha256 cellar: :any, arm64_big_sur:  "b93f151dfdd053cf4b2a97988b3f3d250a6536692c92d2b21dfca25fcd8cdeb4"
    sha256 cellar: :any, monterey:       "ff3132f3db7964e49134803ba44973ce56e54b39045d737ca31897297dd21217"
    sha256 cellar: :any, big_sur:        "2044b5de144d1a0b947dc3021aed15d1bcbf68346f2200643e0579fc9833d79c"
    sha256 cellar: :any, catalina:       "548edca3fe604dafee249c9d30952abd1a34981bf7224e01b784c84dfefab5bf"
    sha256               x86_64_linux:   "be7eb87e0a3cc148ecd202d86cbc7365126559b1ef9e529a18396179c19e11ba"
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
    url "https://files.pythonhosted.org/packages/44/af/58684ce08013c0e16839662844b29cd73259a909982c4d6517ce5ffda05f/PyQt3D-5.15.5.tar.gz"
    sha256 "c025e8a2de12a27e3bd34671d01cac39f78305128cc6cea3f0ba99e4ca3ec41b"
  end

  resource "chart" do
    url "https://files.pythonhosted.org/packages/b3/14/a9fdca9b002f5bf01cf66f9854c65fd6b7ea12523e9e6ef063b0aba0e9e1/PyQtChart-5.15.5.tar.gz"
    sha256 "e2cd55a8a72cef99bc0126f3b1daa914eb5f21e20a70127b6985299f1dc50107"
  end

  resource "datavis" do
    url "https://files.pythonhosted.org/packages/9c/ff/6ba767b4e1dbc32c7ffb93cd5d657048f6a4edf318c5b8810c8931a1733b/PyQtDataVisualization-5.15.5.tar.gz"
    sha256 "8927f8f7aa70857ef00c51e3dfbf6f83dd9f3855f416e0d531592761cbb9dc7f"
  end

  resource "networkauth" do
    url "https://files.pythonhosted.org/packages/85/b6/6b8f30ebd7c15ded3d91ed8d6082dee8aebaf79c4e8d5af77b1172c805c2/PyQtNetworkAuth-5.15.5.tar.gz"
    sha256 "2230b6f56f4c9ad2e88bf5ac648e2f3bee9cd757550de0fb98fe0bcb31217b16"
  end

  resource "webengine" do
    url "https://files.pythonhosted.org/packages/60/66/56e118abb4cddd8e4bea6f89bdec834069b52479fb991748f1b21950811e/PyQtWebEngine-5.15.5.tar.gz"
    sha256 "ab47608dccf2b5e4b950d5a3cc704b17711af035024d07a9b71ad29fc103b941"
  end

  resource "purchasing" do
    url "https://files.pythonhosted.org/packages/41/2a/354f0ae3fa02708719e2ed6a8c310da4283bf9a589e2a7fcf7dadb9638af/PyQtPurchasing-5.15.5.tar.gz"
    sha256 "8bb1df553ba6a615f8ec3d9b9c5270db3e15e831a6161773dabfdc1a7afe4834"
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
