class PyqtAT5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/e1/57/2023316578646e1adab903caab714708422f83a57f97eb34a5d13510f4e1/PyQt5-5.15.7.tar.gz"
  sha256 "755121a52b3a08cb07275c10ebb96576d36e320e572591db16cfdbc558101594"
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
    url "https://files.pythonhosted.org/packages/39/5f/fd9384fdcb9cd0388088899c110838007f49f5da1dd1ef6749bfb728a5da/PyQt5_sip-12.11.0.tar.gz"
    sha256 "b4710fd85b57edef716cc55fae45bfd5bfac6fc7ba91036f1dcc3f331ca0eb39"
  end

  resource "3d" do
    url "https://files.pythonhosted.org/packages/44/af/58684ce08013c0e16839662844b29cd73259a909982c4d6517ce5ffda05f/PyQt3D-5.15.5.tar.gz"
    sha256 "c025e8a2de12a27e3bd34671d01cac39f78305128cc6cea3f0ba99e4ca3ec41b"
  end

  resource "chart" do
    url "https://files.pythonhosted.org/packages/eb/17/1d9bb859b3e09a06633264ad91249ede0abd68c1e3f2f948ae7df94702d3/PyQtChart-5.15.6.tar.gz"
    sha256 "2691796fe92a294a617592a5c5c35e785dc91f7759def9eb22da79df63762339"
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
    url "https://files.pythonhosted.org/packages/cf/4b/ca01d875eff114ba5221ce9311912fbbc142b7bb4cbc4435e04f4f1f73cb/PyQtWebEngine-5.15.6.tar.gz"
    sha256 "ae241ef2a61c782939c58b52c2aea53ad99b30f3934c8358d5e0a6ebb3fd0721"
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

    components = %w[3d chart datavis networkauth purchasing webengine]
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
      WebEngineWidgets
      Widgets
      Xml
    ].each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt5.Qt#{mod}" }
  end
end
