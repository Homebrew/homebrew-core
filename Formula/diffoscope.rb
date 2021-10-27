class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/bb/94/2d4e7212bc52e11ee4ef64656de9343c40973f81bc88b500b92afa8667f0/diffoscope-188.tar.gz"
  sha256 "cdbc401c78d59779ad8ebbb8e2008166f912e77c7ed3be8dc788d36948712ff5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbb0bec9f8cb1a183caf6a5f61b6ac427b84cea902a764957a7dc8c3d32d0d4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93c029895c469370d57a2f49830110ed2bd78754a32ee5d1ea8c17a840075590"
    sha256 cellar: :any_skip_relocation, monterey:       "03b938b9dd2aee36daea43f3d3aeb279622ffb198c8505cd29b9b781f0ea6633"
    sha256 cellar: :any_skip_relocation, big_sur:        "f26eaa3835d47e2e370ea7afddc0ef1698b5c0c497758f5347fbf394d54dd395"
    sha256 cellar: :any_skip_relocation, catalina:       "6a78edd213397e8d68825b157a6ec55f0811593212cc6e6de9f2ef4db9720163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d360ef855698ed30e626044ed4068794ae33871f5d2a5e367a872ad94831e40"
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
