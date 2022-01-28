class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/7d/87/76a8d35c4aedea51816327062913ecd01d578bdbf41494ff365af144b329/diffoscope-202.tar.gz"
  sha256 "cf0d4e1505818403ec8678fd9b8b4c3b955fb1d041c5d826e69f20021bff8a1e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fb6d862f2a8252fde5f4c86a6742ca9e5a99f2915f1c7bbfedede80921908e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d62fef741cc157af514223d37ca58bb0211282ec32876fdc9e9f3951d921b5d"
    sha256 cellar: :any_skip_relocation, monterey:       "424bb9b486be2cb09e373ff841bc9b138381044bff47a49139a852eb053ad7cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2f0c9c5254b65e8a323d926d13005a77b35c5d6c56b973533212f3307fe8a3f"
    sha256 cellar: :any_skip_relocation, catalina:       "9eeed8a47b9ad707cb44ff9900d1d721355ef961cb039097b93cd3a78d557af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee969db7216ed972756c76c713e4a625af02e5905b8a1dae137469ee05407cc6"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/93/c4/d8fa5dfcfef8aa3144ce4cfe4a87a7428b9f78989d65e9b4aa0f0beda5a8/libarchive-c-4.0.tar.gz"
    sha256 "a5b41ade94ba58b198d778e68000f6b7de41da768de7140c984f71d7fa8416e5"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/3a/70/76b185393fecf78f81c12f9dc7b1df814df785f6acb545fc92b016e75a7e/python-magic-0.4.24.tar.gz"
    sha256 "de800df9fb50f8ec5974761054a708af6e4246b03b4bdaee993f948947b0ebcf"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "--progress", "test1", "test2"
  end
end
