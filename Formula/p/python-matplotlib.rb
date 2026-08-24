class PythonMatplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https://matplotlib.org/"
  url "https://files.pythonhosted.org/packages/49/64/f9a391af28f518b11ad45a8a712353c94a0aefce09d3703200e5c54b610a/matplotlib-3.11.1.tar.gz"
  sha256 "69647db5746941c793d6e445a4cd349323ffb87d9cc958c2ad84a659b4832d30"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c5e9bd293aa2e7d4484aec924925db10025f371eea34ee0fc8840292218d124f"
    sha256 cellar: :any, arm64_sequoia: "f1915ea710b6778b4844fd67261af9297330706a015a280f1bfd8136f48ea94b"
    sha256 cellar: :any, arm64_sonoma:  "b350fc37e822606245f99bd8ec33764dde0b2e960c882198614dec4b69147c78"
    sha256 cellar: :any, sonoma:        "ca2b5806a421e0daee3e63283a6e800a020b954cc486b2c377220fce205bf8f4"
    sha256 cellar: :any, arm64_linux:   "3009a0d8d45d579f79b518fd74c2384ba0cadad315ebe4e8216d25db1754674b"
    sha256 cellar: :any, x86_64_linux:  "d8d38646475cdba6007eaccb34dfefb627754f2d1065c77786c49f1e64378821"
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
    url "https://files.pythonhosted.org/packages/84/69/c97f2c18e0db87d2c7b15da1974dace76ae938f1cfa22e2727a648b7ed43/fonttools-4.63.0.tar.gz"
    sha256 "caeb583deeb5168e694b65cda8b4ee62abedfa66cf88488734466f2366b9c4e0"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/d0/67/9c61eccb13f0bdca9307614e782fec49ffdde0f7a2314935d489fa93cd9c/kiwisolver-1.5.0.tar.gz"
    sha256 "d4193f3d9dc3f6f79aaed0e5637f45d98850ebf01f7ca20e69457f3e8946b66a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
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
