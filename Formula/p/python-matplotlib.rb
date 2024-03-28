class PythonMatplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https://matplotlib.org/"
  url "https://files.pythonhosted.org/packages/9a/aa/607a121331d5323b164f1c0696016ccc9d956a256771c4d91e311a302f13/matplotlib-3.8.3.tar.gz"
  sha256 "7b416239e9ae38be54b028abbf9048aff5054a9aba5416bef0bd17f9162ce161"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "801d70321d530196d7a7a003d9be4b0f9ab789e9cc9afb234f0d1662689bd695"
    sha256 cellar: :any,                 arm64_ventura:  "35e41626f2d17d81744dc53384495d8b90e2e8c57ee367fa20dac3815ab2da01"
    sha256 cellar: :any,                 arm64_monterey: "93a4146550385c36d602ff63983ed78d56b3fdfc25e774468ac9ad5f76b4d407"
    sha256 cellar: :any,                 sonoma:         "c4a9ec07272dfefff5ca0542b679eae016bb35cafd525ff7093862d9472d3806"
    sha256 cellar: :any,                 ventura:        "2d63031281c6ec16ee53a5d14174558e0bbcb114eb2e986b21c6cae44c65b5cd"
    sha256 cellar: :any,                 monterey:       "a3319c084ad97a4cc7c31a4485dd7027c33a6608f8245a0d4f46cd19822426dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d62510ab0add381615c5588e975266b83d006f2370e6dde73eb837ea950fc8d3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "qhull"

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with :gcc do
    version "6"
    cause "Requires C++17 compiler"
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/11/a3/48ddc7ae832b000952cf4be64452381d150a41a2299c2eb19237168528d1/contourpy-1.2.0.tar.gz"
    sha256 "171f311cb758de7da13fc53af221ae47a5877be5a0843a9fe150818c51ed276a"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/52/c0/b117fe560be1c7bf889e341d1437c207dace4380b10c14f9c7a047df945b/fonttools-4.49.0.tar.gz"
    sha256 "ebf46e7f01b7af7861310417d7c49591a85d99146fc23a5ba82fdb28af156321"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/b9/2d/226779e405724344fc678fcc025b812587617ea1a48b9442628b688e85ea/kiwisolver-1.4.5.tar.gz"
    sha256 "e57e563a57fb22a142da34f38acc2fc1a5c864bc29ca1517a88abc963e60d6ec"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def python3
    "python3.12"
  end

  def install
    # `matplotlib` needs extra inputs to use system libraries.
    # Ref: https://github.com/matplotlib/matplotlib/blob/v3.8.3/doc/users/installing/dependencies.rst#use-system-libraries
    # TODO: Update build to use `--config-settings=setup-args=...` when `matplotlib` switches to `meson-python`.
    ENV["MPLSETUPCFG"] = buildpath/"mplsetup.cfg"
    (buildpath/"mplsetup.cfg").write <<~EOS
      [libs]
      system_freetype = true
      system_qhull = true
    EOS

    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      `matplotlib` is no longer linked into shared site-packages to avoid contamination
      and align with Homebrew's documented requirements for Python library formulae.
      To use the library, you will need to update your PYTHONPATH to include the directory:
      #{opt_libexec/Language::Python.site_packages(python3)}

      See https://docs.brew.sh/Python-for-Formula-Authors
      See https://docs.brew.sh/Homebrew-and-Python#pep-668-python312-and-virtual-environments
      See https://github.com/Homebrew/homebrew-core/issues/157500
    EOS
  end

  test do
    backend = shell_output("#{libexec}/bin/python -c 'import matplotlib; print(matplotlib.get_backend())'").chomp
    assert_equal OS.mac? ? "MacOSX" : "agg", backend
  end
end
