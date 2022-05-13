class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/1f/cf/e98d1a0031fc8d1ee970a150147c2b834297eb521124738844d4d7e9d0c3/diffoscope-212.tar.gz"
  sha256 "744260ccf2bb869c58c50dfab68957dd494b12e446520993d0925b2394ea1db7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "834b61e7b534b0439d32a2940e2b1a04d8d6bfb274fa5a7d3cce59ec82155a10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ea934bf03350e839c4060267a2758238d6ac4d9e7c0166a44c4829816e7ed34"
    sha256 cellar: :any_skip_relocation, monterey:       "73b20faf89b41a4c061ef3dab2da5881406c3149060777b24d2eed21534e6f13"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa20c8d55b1ee775b82023bca4cf0601a7d6b7feba3a5ffb510efbe3043cf855"
    sha256 cellar: :any_skip_relocation, catalina:       "046173554b02cf02b42c4f660deeed5c89e3f94ac6bdf995041d91ed2a16686e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42921bd032163070b91596c28918d39169291b43e594acf9242ebbe32107e663"
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
    url "https://files.pythonhosted.org/packages/f7/46/fecfd32c126d26c8dd5287095cad01356ec0a761205f0b9255998bff96d1/python-magic-0.4.25.tar.gz"
    sha256 "21f5f542aa0330f5c8a64442528542f6215c8e18d2466b399b0d9d39356d83fc"
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
