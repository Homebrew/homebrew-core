class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/f5/06/8c62b445179161c05cd0622b06b7deae84fde49221668931b1de735bff4b/diffoscope-264.tar.gz"
  sha256 "ca3f34f81e343baf2ad87c9397f2aa387204d537f4d292c174ddd3f34a3dd98c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "202ba66ffec53339fb56eb6898d39dd46a4db29c237ed2d727a31c35e310931a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "202ba66ffec53339fb56eb6898d39dd46a4db29c237ed2d727a31c35e310931a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "202ba66ffec53339fb56eb6898d39dd46a4db29c237ed2d727a31c35e310931a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5a242c56d0f44f73ddc236851e26db3afffc2eca8a45b486d1778cd46404f2c"
    sha256 cellar: :any_skip_relocation, ventura:        "d5a242c56d0f44f73ddc236851e26db3afffc2eca8a45b486d1778cd46404f2c"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a242c56d0f44f73ddc236851e26db3afffc2eca8a45b486d1778cd46404f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "836950085a8aa1a8577a2c2fb2a05310fbdceca5a1f1621f510ad51227698068"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/3c/c0/031c507227ce3b715274c1cd1f3f9baf7a0f7cec075e22c7c8b5d4e468a9/argcomplete-3.2.3.tar.gz"
    sha256 "bf7900329262e481be5a15f56f19736b376df6f82ed27576fa893652c5de6c23"
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
