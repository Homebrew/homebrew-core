class PythonMatplotlib < Formula
  include Language::Python::Virtualenv

  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https://matplotlib.org/"
  url "https://files.pythonhosted.org/packages/a0/59/c3e6453a9676ffba145309a73c462bb407f4400de7de3f2b41af70720a3c/matplotlib-3.10.6.tar.gz"
  sha256 "ec01b645840dd1996df21ee37f208cd8ba57644779fa20464010638013d3203c"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2df5888f5a87633dadd4c1d79af5aadc20b9cef4877f9a35e054add117868b71"
    sha256 cellar: :any,                 arm64_sequoia: "7290166c80a49c238b6e5476e337a6467f1143f413daa936bd886da7b80f20d5"
    sha256 cellar: :any,                 arm64_sonoma:  "ff7155fe2cea3e763b41785fafb8535a2d439cebce126800f302f30d0922b67a"
    sha256 cellar: :any,                 arm64_ventura: "379836b9f39b2a531593c9f42f75b9ab048ad656a24ded9bfcd829232c980278"
    sha256 cellar: :any,                 sonoma:        "fa01a020139c182a34d307b75f0b7cd8f67b27641de52fb59f4ed272c77b0c91"
    sha256 cellar: :any,                 ventura:       "e956ffe9e05e24181af33c8f339373429db40f788346aa27769eeb4255efcee5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28d16838d8b5f4f2f7b77716b2f913c98062fc0353f3e8025f2cfe5727a2063b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c753763fafc2eb68b21608d823299dec3d2552b893b627b2a0b614fc7fb551e9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "qhull"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/58/01/1253e6698a07380cd31a736d248a3f2a50a7c88779a1813da27503cadc2a/contourpy-1.3.3.tar.gz"
    sha256 "083e12155b210502d0bca491432bb04d56dc3432f95a979b429f2848c3dbe880"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/0d/a5/fba25f9fbdab96e26dedcaeeba125e5f05a09043bf888e0305326e55685b/fonttools-4.59.2.tar.gz"
    sha256 "e72c0749b06113f50bcb80332364c6be83a9582d6e3db3fe0b280f996dc2ef22"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/5c/3c/85844f1b0feb11ee581ac23fe5fce65cd049a200c1446708cc1b7f922875/kiwisolver-1.4.9.tar.gz"
    sha256 "c3b22c26c6fd6811b0ae8363b95ca8ce4ea3c202d3d0975b2914310ceb1bcc4d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
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
    which("python3.13")
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
