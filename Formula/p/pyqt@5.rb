class PyqtAT5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/5c/46/b4b6eae1e24d9432905ef1d4e7c28b6610e28252527cdc38f2a75997d8b5/PyQt5-5.15.9.tar.gz"
  sha256 "dc41e8401a90dc3e2b692b411bd5492ab559ae27a27424eed4bd3915564ec4c0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9398c47f03210dddad2db4419553223f43113d7fe302656b20f6aa5fd0b3eecf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdebe6cce54a45c856b8b2237308f4ba53e45ea0bc460769b615f557bc69ac09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83b6ea13c4b1389d0fe758bcd9f83b8d6564b8b6abbfc05c57ce102d4734940d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0926e76447c749f669f1a2cc13c9fa06ff2da0ae8071c62d1e96f8ea1357227f"
    sha256 cellar: :any,                 sonoma:         "e069472245fac9dd5d02dffd92a9af711763757a4330dfd1b7b7278539304df4"
    sha256 cellar: :any_skip_relocation, ventura:        "e05bf795d62839535e0e0e6ee6c70a6bef82bc90a953de0393c21ed1f870b4bb"
    sha256 cellar: :any_skip_relocation, monterey:       "04905257fd09737552946add20a940e065cbe973080bc60c63022f0b5cacc939"
    sha256 cellar: :any_skip_relocation, big_sur:        "25533e0e23fb89a027e17c991cc9ddd0dc76c3d4805acc4f1d6f3e506bde88b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccf729fadf5aec8e76778c9ea6cc1abe3a1abe6c19016a56a4a7713348dcd45f"
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
    url "https://files.pythonhosted.org/packages/c1/61/4055e7a0f36339964956ff415e36f4abf82561904cc49c021da32949fc55/PyQt5_sip-12.12.1.tar.gz"
    sha256 "8fdc6e0148abd12d977a1d3828e7b79aae958e83c6cb5adae614916d888a6b10"
  end

  resource "PyQt3D" do
    url "https://files.pythonhosted.org/packages/a5/80/26e3394c25187854bd3b68865b2b46cfd285aae01bbf448ddcac6f466af0/PyQt3D-5.15.6.tar.gz"
    sha256 "7d6c6d55cd8fc221b313c995c0f8729a377114926f0377f8e9011d45ebf3881c"
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
