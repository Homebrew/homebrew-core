class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/21/fb/425f842a8066fef249aa46fe1e42dc1e750ffccbc54b147048497aca7710/diffoscope-284.tar.gz"
  sha256 "c672e97ce3e69c229858419e8d368563bb583101a9cfc5eb70e28d441502b1b7"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f12e20bc21a5477d1a99b2b38108eb3a7e2c052427c7391e4e2d72bd841d1b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f12e20bc21a5477d1a99b2b38108eb3a7e2c052427c7391e4e2d72bd841d1b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f12e20bc21a5477d1a99b2b38108eb3a7e2c052427c7391e4e2d72bd841d1b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ec3a70b425bebe764c6c31258c3477f05c7c9852c4c95b4f0c077948b13358c"
    sha256 cellar: :any_skip_relocation, ventura:       "1ec3a70b425bebe764c6c31258c3477f05c7c9852c4c95b4f0c077948b13358c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "275125bf67a331f0ee2b1cdc9218f641ff3ab43d62446c9f519e0982481f8c1d"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/7f/03/581b1c29d88fffaa08abbced2e628c34dd92d32f1adaed7e42fc416938b0/argcomplete-3.5.2.tar.gz"
    sha256 "23146ed7ac4403b70bd6026402468942ceba34a6732255b9edf5b7354f68a6bb"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/a0/f9/3b6cd86e683a06bc28b9c2e1d9fe0bd7215f2750fd5c85dce0df96db8eca/libarchive-c-5.1.tar.gz"
    sha256 "7bcce24ea6c0fa3bc62468476c6d2f6264156db2f04878a372027c10615a2721"
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
    venv = virtualenv_create(libexec, "python3.13")
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
