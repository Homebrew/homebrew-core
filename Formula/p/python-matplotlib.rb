class PythonMatplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https://matplotlib.org/"
  url "https://files.pythonhosted.org/packages/e7/c8/9aa712a0afb882649424dd8de8ad9aa6235e796e84c6052e8f6dc1598d0d/matplotlib-3.11.2.tar.gz"
  sha256 "cec596316640f2b394b8f0daa0ea61a8eae82d017b620b9f202befb972a59ea4"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ad8018901617d5ffeaf255d71e74730683690fdeb22812ea2a79ad2582cfb0b7"
    sha256 cellar: :any, arm64_tahoe:       "c5e9bd293aa2e7d4484aec924925db10025f371eea34ee0fc8840292218d124f"
    sha256 cellar: :any, arm64_sequoia:     "f1915ea710b6778b4844fd67261af9297330706a015a280f1bfd8136f48ea94b"
    sha256 cellar: :any, arm64_sonoma:      "b350fc37e822606245f99bd8ec33764dde0b2e960c882198614dec4b69147c78"
    sha256 cellar: :any, sonoma:            "ca2b5806a421e0daee3e63283a6e800a020b954cc486b2c377220fce205bf8f4"
    sha256 cellar: :any, arm64_linux:       "3009a0d8d45d579f79b518fd74c2384ba0cadad315ebe4e8216d25db1754674b"
    sha256 cellar: :any, x86_64_linux:      "d8d38646475cdba6007eaccb34dfefb627754f2d1065c77786c49f1e64378821"
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
    url "https://files.pythonhosted.org/packages/83/5a/a55177dd22553a277388e8a1b3220e92de91bacb28356cdc73caa240121d/contourpy-1.4.0.tar.gz"
    sha256 "20156f5a1ac4f8ce02656e39a61e82164a3d359796dc8026f75b062783d500e1"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/77/51/d63c7e52163ac14393a35bd14bd7c0da95f8f74be5d7cc988092f9965129/fonttools-4.65.0.tar.gz"
    sha256 "762ba5431358d0dbd4a01982484a1d494fb267e91f974cdcf20b80eab8560f6f"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/ba/07/bd78e6a8fae171ea041ef5bba3ed21a003522fa088834b069b1909981f30/kiwisolver-1.5.1.tar.gz"
    sha256 "f1303ef2eec81262a4b708c3e858afe58d7c75ad91c1c05266eda7673369859a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
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
