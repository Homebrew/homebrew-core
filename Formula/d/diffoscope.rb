class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/a7/7f/fb908e880d1c4e7dc3977a66dbc1c5a5bb5a3875795d43e35f47bbc48e63/diffoscope-281.tar.gz"
  sha256 "69ef72384692f59c551119bfb44e72451c0de777fa673d0b2a49e11b3747cb2f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c74f9942362e0faa7166b0e353e0176388621abc9f2386615c508b80ebb8761"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c74f9942362e0faa7166b0e353e0176388621abc9f2386615c508b80ebb8761"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c74f9942362e0faa7166b0e353e0176388621abc9f2386615c508b80ebb8761"
    sha256 cellar: :any_skip_relocation, sonoma:        "70e25cb7b960fa65b3582b4ab50a0e146fdb7678eeb405e06576698d0355ce52"
    sha256 cellar: :any_skip_relocation, ventura:       "70e25cb7b960fa65b3582b4ab50a0e146fdb7678eeb405e06576698d0355ce52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd9e3d163be1b53d9823d57a378df356782933a3f46107c2d33e533a01c2c57c"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/5f/39/27605e133e7f4bb0c8e48c9a6b87101515e3446003e0442761f6a02ac35e/argcomplete-3.5.1.tar.gz"
    sha256 "eb1ee355aa2557bd3d0145de7b06b2a45b0ce461e1e7813f5d066039ab4177b4"
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
