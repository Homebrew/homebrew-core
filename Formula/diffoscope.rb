class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/54/05/d8833330abea8ecb2443c142630a7123ee1bb248ca591e945f65c10586d1/diffoscope-232.tar.gz"
  sha256 "1fd10b465d3566e6f65bdc00b6a814ff129900a2f4f9f4bae922069467214082"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd82f3554ad942efb9fcb5bc5f0fa786d70eef9d97cc0e18242ab80fef6e8e50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d2e382881b40dc2dc9a1ff6ae5357ff1428e3cb81438594add6515ef54f61cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "236cf6d765e846633680eaef77510a9ece0ad31908dbc5392cb3abc24929247a"
    sha256 cellar: :any_skip_relocation, ventura:        "022a12cbed9808ed8159be4d57b6ff919218e9f46f546b223b8286d63bf43c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "663e54be2da09ff8dc3a90288573a71fe3949db8525e074e182d28d34e306d04"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1f6d61fd624483bf7608f8f29d6d9a04461c93d70c63a0351c4e6b62df2b988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51315fd7f52d0fca1c94af6cd23b3eb5b04d2a0421d9e0d6b75401a04e577a7c"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.11"

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
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system bin/"diffoscope", "--progress", "test1", "test2"
  end
end
