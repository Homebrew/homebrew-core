class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/94/b0/100ac8b34502a97ee927a277981ded9aaa0ad0bb1ba19b85fde0bf9ea411/diffoscope-201.tar.gz"
  sha256 "07bd0b2972e7c4926db7f65bcf23fd106ad42169dbdaef3dc63278af82c5e38f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76af9397aa11516ec57ae92814ace8ee3eff07056b0fa8ee7d644feb9ac396d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c58888a0caaff411246547d269fd83ca876404c4286aad182399bcd2fb1c4b1"
    sha256 cellar: :any_skip_relocation, monterey:       "7045431eb21b14cfa22e1eef4b137fc8032fcb10acc8b4531f10b579855dcaf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1adf329f577083569f3ee34b25051bb4156af278e3ac80a8cf75af7bbf366941"
    sha256 cellar: :any_skip_relocation, catalina:       "226dac40ccee65a3269f1a4ec03f9b935739e2123c147578beb9658f0f3c7c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d20d0b66737dd48638841dd78f7f3b4b25b22077540fa4517022aa44e6dc1189"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
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
