class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/48/5b/b10a8052d06bc324f201b7f88dd70091618f69c829169d610a67c05cb5c9/diffoscope-190.tar.gz"
  sha256 "29e3c5ce764b494771876aef3f587ed4867374a0f4e28afe39d4f0640ddb7744"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2683daf17eaab2e5b6520457703df3d5b698ceb4efc0a8651f89df4dc0805e59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05bcaae02b5afc012f719bf52b8bb9e84ef5cdf05fc7b0b897d0ab808b62b7d6"
    sha256 cellar: :any_skip_relocation, monterey:       "87a721f3424e2aa3a0bce412a43fb3ed850d3e9a211c36c4788b62895aadb802"
    sha256 cellar: :any_skip_relocation, big_sur:        "04b132ae8fe45f907da9c71abd465938bce1bb875b0066842704162c785c6d86"
    sha256 cellar: :any_skip_relocation, catalina:       "aec00cd4defe80db1acaed5f046633e91f11a05b9059ecfd0c5ba2f3f0ecb3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68b0ecd62722511bc80958e55be010012003a97de117578cd246046db299d4fc"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

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
