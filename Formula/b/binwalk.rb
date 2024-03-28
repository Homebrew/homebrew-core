class Binwalk < Formula
  include Language::Python::Virtualenv

  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/ReFirmLabs/binwalk"
  url "https://github.com/ReFirmLabs/binwalk/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "60416bfec2390cec76742ce942737df3e6585c933c2467932f59c21e002ba7a9"
  license "MIT"
  revision 1
  head "https://github.com/ReFirmLabs/binwalk.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "a9c16c0ea6712b324582b678a6bb0f89186229375b2167d35697c434a3fe831e"
    sha256 cellar: :any,                 arm64_ventura:  "cbc1609002b6673a9609f3af058428e3e71f3d517c66878e2fd02d4bae4732e2"
    sha256 cellar: :any,                 arm64_monterey: "f76c9432dbfbe81f8f9031c10bde58f2deb41fad4397e45c788a541a936cf7a1"
    sha256 cellar: :any,                 sonoma:         "541c4dd02cc7f0455e49b54b83df80ff7aea921263d76a2b51afa3c13e3f6f98"
    sha256 cellar: :any,                 ventura:        "de5c3ab5d6f3fc81a341aadd5e5ad1f9d9e139598f7e3ecda1aa316f26f889d3"
    sha256 cellar: :any,                 monterey:       "c40d4df1e272b1d50970f969da0e1b889a8b7c70bf60406e12641217a068b481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e23a0c1cfd5ccb70085fb00191d971b545c79d5dfc3aa2693b9a552665db0d5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "numpy"
  depends_on "p7zip"
  depends_on "pillow"
  depends_on "python@3.11" # Python 3.12 issue: https://github.com/ReFirmLabs/binwalk/issues/507
  depends_on "qhull"
  depends_on "ssdeep"
  depends_on "xz"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/7a/fe/e6cdc4ad6e0d9603fa662d1ccba6301c0cb762a1c90a42c7146a538c24e9/capstone-5.0.1.tar.gz"
    sha256 "740afacc29861db591316beefe30df382c4da08dcb0345a0d10f0cac4f8b1ee2"
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/11/a3/48ddc7ae832b000952cf4be64452381d150a41a2299c2eb19237168528d1/contourpy-1.2.0.tar.gz"
    sha256 "171f311cb758de7da13fc53af221ae47a5877be5a0843a9fe150818c51ed276a"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/c4/e6/c1ac50fe3eebb38a155155711e6e864e254ce4b6e17fe2429b4c4d5b9e80/flit_core-3.9.0.tar.gz"
    sha256 "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/dd/e5/9adc30ebca9009d5ad36c7e74462ee5fc51985ca9a845fd26f9f5c99b3df/fonttools-4.47.0.tar.gz"
    sha256 "ec13a10715eef0e031858c1c23bfaee6cba02b97558e4a7bfa089dba4a8c2ebf"
  end

  resource "gnupg" do
    url "https://files.pythonhosted.org/packages/96/6c/21f99b450d2f0821ff35343b9a7843b71e98de35192454606435c72991a8/gnupg-2.3.1.tar.gz"
    sha256 "8db5a05c369dbc231dab4c98515ce828f2dffdc14f1534441a6c59b71c6d2031"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/b9/2d/226779e405724344fc678fcc025b812587617ea1a48b9442628b688e85ea/kiwisolver-1.4.5.tar.gz"
    sha256 "e57e563a57fb22a142da34f38acc2fc1a5c864bc29ca1517a88abc963e60d6ec"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/fb/ab/38a0e94cb01dacb50f06957c2bed1c83b8f9dac6618988a37b2487862944/matplotlib-3.8.2.tar.gz"
    sha256 "01a978b871b881ee76017152f1f1a0cbf6bd5f7b8ff8c96df0df1bd57d8755a1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b1/38/42a8855ff1bf568c61ca6557e2203f318fb7afeadaf2eb8ecfdbde107151/pycryptodome-3.19.1.tar.gz"
    sha256 "8ae0dd1bcfada451c35f9e29a3e5db385caabc190f98e4a80ad02a61098fb776"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    # `matplotlib` needs extra inputs to use system libraries.
    # Ref: https://github.com/matplotlib/matplotlib/blob/v3.8.1/doc/devel/dependencies.rst#use-system-libraries
    # TODO: Update build to use `--config-settings=setup-args=...` when `matplotlib` switches to `meson-python`.
    ENV["MPLSETUPCFG"] = buildpath/"mplsetup.cfg"
    (buildpath/"mplsetup.cfg").write <<~EOS
      [libs]
      system_freetype = true
      system_qhull = true
    EOS

    virtualenv_install_with_resources
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
