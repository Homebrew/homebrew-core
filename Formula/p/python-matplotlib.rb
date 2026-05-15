class PythonMatplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https://matplotlib.org/"
  url "https://files.pythonhosted.org/packages/63/1b/4be5be87d43d327a0cf4de1a56e86f7f84c89312452406cf122efe2839e6/matplotlib-3.10.9.tar.gz"
  sha256 "fd66508e8c6877d98e586654b608a0456db8d7e8a546eb1e2600efd957302358"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec8c36ce9aae1524784085ef291d01c0940ad6b5636d25b223bb06d651c94d85"
    sha256 cellar: :any,                 arm64_sequoia: "0be1a830abd74386667e0e18214fee5de9a892f4adfe49ed45bce4507a655230"
    sha256 cellar: :any,                 arm64_sonoma:  "02ccdae11db869d309978edd4177d8095cb17769d1e1cfa4c24076b9352ffd0b"
    sha256 cellar: :any,                 sonoma:        "d5f787e85ee36a4d45b0f92e3fb5af30a8faa2c96c43c3ed4f48e6cb31002ca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f241492274735cb11e696b9825a09e87276b2e7dc506c138012270e998a7b84a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "155cab952a97ea021cab51a57a3cb317bf97eb95675743c407f58fcc9c7dc744"
  end

  depends_on "cmake" => :build # for contourpy
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "numpy"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"
  depends_on "qhull"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: %w[numpy pillow]

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/58/01/1253e6698a07380cd31a736d248a3f2a50a7c88779a1813da27503cadc2a/contourpy-1.3.3.tar.gz"
    sha256 "083e12155b210502d0bca491432bb04d56dc3432f95a979b429f2848c3dbe880"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/9a/08/7012b00a9a5874311b639c3920270c36ee0c445b69d9989a85e5c92ebcb0/fonttools-4.62.1.tar.gz"
    sha256 "e54c75fd6041f1122476776880f7c3c3295ffa31962dc6ebe2543c00dca58b5d"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/d0/67/9c61eccb13f0bdca9307614e782fec49ffdde0f7a2314935d489fa93cd9c/kiwisolver-1.5.0.tar.gz"
    sha256 "d4193f3d9dc3f6f79aaed0e5637f45d98850ebf01f7ca20e69457f3e8946b66a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/de/0d2b39fb4af88a0258f3bac87dfcbb48e73fbdea4a2ed0e2213f9a4c2f9a/packaging-26.1.tar.gz"
    sha256 "f042152b681c4bfac5cae2742a55e103d27ab2ec0f3d88037136b6bfe7c9c5de"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def python3
    which("python3.14")
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    system python3, "-m", "pip", "--python=#{venv.root}", "install",
                                 "--config-settings=setup-args=-Dsystem-freetype=true",
                                 "--config-settings=setup-args=-Dsystem-qhull=true",
                                 *std_pip_args(prefix: false, build_isolation: true), "."

    (prefix/Language::Python.site_packages(python3)/"homebrew-matplotlib.pth").write venv.site_packages
  end

  test do
    backend = shell_output("#{python3} -c 'import matplotlib; print(matplotlib.get_backend())'").chomp
    assert_equal OS.mac? ? "macosx" : "agg", backend
  end
end
