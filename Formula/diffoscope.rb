class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/a6/1b/85f99018b287762d79fb9f28fa813fd087359f9c63a26c45ba12fc0c024d/diffoscope-197.tar.gz"
  sha256 "abb7dd59fab20f7a142f666aecfd1af2395932e6abc1ad0cedce687ae15f7c1c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55829c7732bcc5d21af964b8d3bbf2396fb05702be8c0864f8593ffb46c6cd36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d863444d32bdb402887fa0bb36816c6dc6077920bbc6f8f3a834ec3a95175fb4"
    sha256 cellar: :any_skip_relocation, monterey:       "ec638ee779601446fa26aa358eb6090ba31736fa641f3e0901cc9133f27b0a56"
    sha256 cellar: :any_skip_relocation, big_sur:        "5efb94769de6eecd31877e4d88d41248401adfa80c908ae2dcd14e0c5409c425"
    sha256 cellar: :any_skip_relocation, catalina:       "8149619e8fb4c699589f0a32ed3b61a2a235cd7f547e524cafeaea83c4099dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "918d8f1a0dcbdb6fe84eb8d0e8f65601a0036788c05f4a7bba44f4374ece1b03"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/0c/91/bf5e8861ab011752fd9f2680ffd9a130cd3990badc722f0e020da2646c28/libarchive-c-3.2.tar.gz"
    sha256 "21ad493f4628972fc82440bff54c834a9fbe13be3893037a4bad332b9ee741e5"
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
