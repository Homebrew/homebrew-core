class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/8a/89/1d0589a1e7182526f479c30462a9951f032ee3bde06f4868203bc9b366ef/diffoscope-220.tar.gz"
  sha256 "7873e13ac8b11b634ee3490b70b056c6a6bae9cfb794d6ba7cb43e7797b2a829"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1391f193372c6351539cd883e89312e396a36522ea2c79180c74c1ddd1596f88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9fc5797dfb056ac8dd3985e847d4c2046f974da50230d519f3f2fdd2ea44fe3"
    sha256 cellar: :any_skip_relocation, monterey:       "78f34a06bcbd322465402616d45a1ff2b7c8ae573dc5f000a29c0608f14257cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ac785233facd3a9005f25c54af4e1db4c5778def1bf5f2d016a42c5c288a59c"
    sha256 cellar: :any_skip_relocation, catalina:       "c891be26d34a342e386b2051edfd7f9110d1a30b2345c2e4e101b05845e624a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9132b49326852883b3d2122384410ba542317c175b819c6a9ffe6837559848d7"
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
