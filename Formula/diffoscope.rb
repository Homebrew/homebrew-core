class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/b4/be/8443fa6d39522250eb50ac9234e9d6e5e63d29383711e975dbacb39f520c/diffoscope-199.tar.gz"
  sha256 "7b07b8ff34e5fe0e57acc8b02bcb9303ae254c40f357fb7ed805e9f9f7c7686f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb7cf95ff39a7a9e030fb6ed81d8d732377abc13dc3abd5ee17ef4d1daef77fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8120fb94edf2309bc89c291ed41101591d626bda00fea066f7ff30d86ae00bad"
    sha256 cellar: :any_skip_relocation, monterey:       "13ad8a9dffad284ebcd74c86e1897fc67f7a56682f3042c19edf1f098fecf436"
    sha256 cellar: :any_skip_relocation, big_sur:        "25fdeda0c54e57c2dd4022fe3072e34510edf57f959330a19d115401e0397b0f"
    sha256 cellar: :any_skip_relocation, catalina:       "7ef65176ff67bd6bd0e330023eaefdf9e41fcc2aeedaba9978fe9dada5a0a0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a25f52f7786a98737030f9ac316ba6a959668c680c1196026ced357f50c796b1"
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
