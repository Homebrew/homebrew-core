class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/78/ce/2f96f0e5c9a3dcc1e3181b2cdb196627340f7c1c1ea6170944afbf5a3a8d/diffoscope-253.tar.gz"
  sha256 "ca3d826b691f4998d6de28a016b3555d56a7283b97ad92944ce643ea6e7eb614"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ba6cb7b53496a50eb92a98bb05c32954639aa24c030a143b366412770929f3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e4ca8eed3e40f30062af7872c717846f36fb504bedb693842530edcdef901eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "602068ba090383e53c2a029410cf2f12b6792b83e6f1b576d7525f5f9a158286"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f6a8d228cbb4d44cecb89d3789d319412648e8212ff8ac439936fe2c8f69763"
    sha256 cellar: :any_skip_relocation, ventura:        "9b51e99336ce3ae92d9fb87220be0e02b54eae0557c9b572cd6f19a24136a504"
    sha256 cellar: :any_skip_relocation, monterey:       "bc88dbfdbc9c27c0f82a1cfae81297c4bfa9a1a906662be10d0dd444e651d416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f179d022621fdf09a9a737b7cb32410467bebeb1010d025dbc1cbd1bd055fa79"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python-argcomplete"
  depends_on "python@3.12"

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
    venv = virtualenv_create(libexec, "python3.12")
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
