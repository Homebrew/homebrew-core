class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/af/19/75a447948abdeba4fc8e9450d738d35e05ed9e478b96b9812ca6d5052154/diffoscope-247.tar.gz"
  sha256 "3b05b4bf6390c7d1d23bf2741d2fc3d4ea65c12608b43420ef38175bd2dd5cfe"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24f00040f8e847e49fc0cbc20d30f83963c84bdfba465476ba86cbddbac26431"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9338b9490b4466fc9c3b6dc9a2c8df55415d6119c7a0c54d679376569b18973f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baeca4b3a1c1840ecb16de8a7c32f5cd2ec7f17631f839246b22600984f392e5"
    sha256 cellar: :any_skip_relocation, ventura:        "5bdeab20258474fce9ae89df63da5058e288714105ae718e6a29553c2346839b"
    sha256 cellar: :any_skip_relocation, monterey:       "8e10b4d4db3c8130444d628c822148882c19bf28b27bcd070f50f5b026159854"
    sha256 cellar: :any_skip_relocation, big_sur:        "100f66ad72c4139f06e9eeb6a20d9aa4c8eb65a681f0ad87778aee0b43f706ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "468cce8f863e51a34568b61991b13249bab6a90aeeb97149a4b6693f3abe577d"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/54/c9/41c4dfde7623e053cbc37ac8bc7ca03b28093748340871d4e7f1630780c4/argcomplete-3.1.1.tar.gz"
    sha256 "6c4c563f14f01440aaffa3eae13441c5db2357b5eec639abe7c0b15334627dff"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/59/d6/eab966f12b33a97c78d319c38a38105b3f843cf7d79300650b7ac8c9d349/libarchive-c-5.0.tar.gz"
    sha256 "d673f56673d87ec740d1a328fa205cafad1d60f5daca4685594deb039d32b159"
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
