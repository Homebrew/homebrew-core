class PyqtAT5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/e1/57/2023316578646e1adab903caab714708422f83a57f97eb34a5d13510f4e1/PyQt5-5.15.7.tar.gz"
  sha256 "755121a52b3a08cb07275c10ebb96576d36e320e572591db16cfdbc558101594"
  license "GPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e36ecd411d274f6c728ee7be982673d8a843795909a1e6a7294a9c287445292"
    sha256 cellar: :any,                 arm64_monterey: "65d02cc59037ca2eb5dd5ac2d5e19fb46debba9a4b418764592b1cec2fdf0975"
    sha256 cellar: :any,                 arm64_big_sur:  "054b7a3aac3ae4030c2989aca8120e97aa347ac8a8341add5b3358a298fda543"
    sha256 cellar: :any,                 ventura:        "6f3b970bf51f05674d2d7e3a50aee7cd2fe8e68e36d2167781714579d9412d7a"
    sha256 cellar: :any,                 monterey:       "d42f26eec225db2710a8e29939d04ab779b3487c7bc614db576c5d44110419c4"
    sha256 cellar: :any,                 big_sur:        "08f088f6a293b8f0246afe3d25142e0d1faf43012d876bd500b979bdcdd9aca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3c706d51bb7d4f4fd8f7839be6a65060267d0939aa8cba042eb4e40f0a8ad49"
  end

  depends_on "pyqt-builder" => :build
  depends_on "python@3.10"  => [:build, :test]
  depends_on "python@3.11"  => [:build, :test]
  depends_on "python@3.9"   => [:build, :test]
  depends_on "sip"          => :build
  depends_on "qt@5"

  fails_with gcc: "5"

  # extra components
  resource "PyQt5-sip" do
    url "https://files.pythonhosted.org/packages/39/5f/fd9384fdcb9cd0388088899c110838007f49f5da1dd1ef6749bfb728a5da/PyQt5_sip-12.11.0.tar.gz"
    sha256 "b4710fd85b57edef716cc55fae45bfd5bfac6fc7ba91036f1dcc3f331ca0eb39"
  end

  resource "PyQt3D" do
    url "https://files.pythonhosted.org/packages/44/af/58684ce08013c0e16839662844b29cd73259a909982c4d6517ce5ffda05f/PyQt3D-5.15.5.tar.gz"
    sha256 "c025e8a2de12a27e3bd34671d01cac39f78305128cc6cea3f0ba99e4ca3ec41b"
  end

  resource "PyQtChart" do
    url "https://files.pythonhosted.org/packages/eb/17/1d9bb859b3e09a06633264ad91249ede0abd68c1e3f2f948ae7df94702d3/PyQtChart-5.15.6.tar.gz"
    sha256 "2691796fe92a294a617592a5c5c35e785dc91f7759def9eb22da79df63762339"
  end

  resource "PyQtDataVisualization" do
    url "https://files.pythonhosted.org/packages/9c/ff/6ba767b4e1dbc32c7ffb93cd5d657048f6a4edf318c5b8810c8931a1733b/PyQtDataVisualization-5.15.5.tar.gz"
    sha256 "8927f8f7aa70857ef00c51e3dfbf6f83dd9f3855f416e0d531592761cbb9dc7f"
  end

  resource "PyQtNetworkAuth" do
    url "https://files.pythonhosted.org/packages/85/b6/6b8f30ebd7c15ded3d91ed8d6082dee8aebaf79c4e8d5af77b1172c805c2/PyQtNetworkAuth-5.15.5.tar.gz"
    sha256 "2230b6f56f4c9ad2e88bf5ac648e2f3bee9cd757550de0fb98fe0bcb31217b16"
  end

  resource "PyQtWebEngine" do
    url "https://files.pythonhosted.org/packages/cf/4b/ca01d875eff114ba5221ce9311912fbbc142b7bb4cbc4435e04f4f1f73cb/PyQtWebEngine-5.15.6.tar.gz"
    sha256 "ae241ef2a61c782939c58b52c2aea53ad99b30f3934c8358d5e0a6ebb3fd0721"
  end

  resource "PyQtPurchasing" do
    url "https://files.pythonhosted.org/packages/41/2a/354f0ae3fa02708719e2ed6a8c310da4283bf9a589e2a7fcf7dadb9638af/PyQtPurchasing-5.15.5.tar.gz"
    sha256 "8bb1df553ba6a615f8ec3d9b9c5270db3e15e831a6161773dabfdc1a7afe4834"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    components = %w[PyQt3D PyQtChart PyQtDataVisualization PyQtNetworkAuth PyQtWebEngine PyQtPurchasing]

    pythons.each do |python|
      site_packages = prefix/Language::Python.site_packages(python)
      args = [
        "--target-dir", site_packages,
        "--scripts-dir", bin,
        "--confirm-license",
        "--no-designer-plugin",
        "--no-qml-plugin"
      ]
      system "sip-install", *args

      resource("PyQt5-sip").stage do
        system python, *Language::Python.setup_install_args(prefix, python)
      end

      components.each do |p|
        resource(p).stage do
          inreplace "pyproject.toml", "[tool.sip.project]", <<~EOS
            [tool.sip.project]
            sip-include-dirs = ["#{site_packages}/PyQt#{version.major}/bindings"]
          EOS
          system "sip-install", "--target-dir", site_packages
        end
      end
    end

    # Replace hardcoded reference to Python version used with sip/pyqt-builder with generic python3.
    bin.children.each { |script| inreplace script, Formula["python@3.11"].opt_bin/"python3.11", "python3" }
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

    pythons.each do |python|
      system python, "-c", "import PyQt#{version.major}"
      components.each { |mod| system python, "-c", "import PyQt5.Qt#{mod}" }
    end
  end
end
