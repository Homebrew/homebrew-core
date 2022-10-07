class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/61/76/bfb524f4752a30051b2a27ae4b7717f1410e09377956c89a101c5813b1c1/diffoscope-224.tar.gz"
  sha256 "1920ebdca40e85f019a84e0220e4a79f00ffdafc0f78e1f1e2219123d5c08dfb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9430994026963f94d4f6b7a82058cf8b4e8db72e62f5137c3f3d952ab4f9aaa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be4049bf05cd6678cdc34906ebb87a508eb058d60b0fe1d90c0f134ad3bfbb9f"
    sha256 cellar: :any_skip_relocation, monterey:       "2b2a2b29236b2e044832331ec02c29898b7fb9dd17e0c818c437ad6c45e4a85a"
    sha256 cellar: :any_skip_relocation, big_sur:        "269a5ab8d21f8979a08eab25c3253f8eecbe589d9105097d389c8bb59c1fc870"
    sha256 cellar: :any_skip_relocation, catalina:       "a39f4410975dbcb103914e5c40f550055d16e82b084d2bbec919e658da84646c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86f3839ec81c1a3f956512088313cb0d76c14337063fa186106376f835ec592c"
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
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")
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
