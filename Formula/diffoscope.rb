class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/01/10/fbe3fc03d33a8eefa12539c8932d4d98a5f98c59f1766d3d31aed7788edd/diffoscope-187.tar.gz"
  sha256 "e8340880eb9cce0d99498f71bcdb69c6cc4385c972b5bc12e739e71eaca29c5a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a94753563bed0e123f4b0342384869c9d55794a25907567cd999c72a8f28efe5"
    sha256 cellar: :any_skip_relocation, big_sur:       "1cbd3d20319ea63153b0301f08b0cb218bf2eba7ab8a6c48ce672eb64f415d29"
    sha256 cellar: :any_skip_relocation, catalina:      "d08e5abf032873ce3236c873b478a395d31d947243089c156df801471b029462"
    sha256 cellar: :any_skip_relocation, mojave:        "031cff331108f19bf1cdbf15c2e03a47c892f3832230bf37c40db4e517441216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ff9e42777845893d13e46e757df5f1e683f9da28fc9af9cbdab5593b8636351"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

  # Use resources from diffoscope[cmdline]
  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/53/d5/bee2190570a2b4c372a022f16ebfc2313ff717a023f277f5d6f9ebf281a2/libarchive-c-3.1.tar.gz"
    sha256 "618a7ecfbfb58ca15e11e3138d4a636498da3b6bc212811af158298530fbb87e"
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
