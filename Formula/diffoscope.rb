class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/94/ad/d231d2b44d115440d1f9dcadea61f8a54da06145bc603da7b434e1c3e506/diffoscope-204.tar.gz"
  sha256 "cc99eb4cd9555947b11d6abb7ba83e71234f92ad1372e3b61e934115192ecb4e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74cf9ec1e1e0c55740d8be74b20f70c82fc8b7c9b46892abdcee349ea21ebb67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15aba476527b666eb0747fc79393434778d9a272007a2ed446bab0c8200598e4"
    sha256 cellar: :any_skip_relocation, monterey:       "3ed1dd6cc33fad7040c21398041430d275d24ac3d8cf71434c178e87ebf9af19"
    sha256 cellar: :any_skip_relocation, big_sur:        "9699cf062e871f1c6501dc80017c45697e31211bdb95284fbe30231ae64bffed"
    sha256 cellar: :any_skip_relocation, catalina:       "b5b5d51b83d239a80ef3237f5957244b89ecfbffe17dd551faa145efdb0dd25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "794f62e7f10ea899d34191e167d8edf5f3259c3ac12365dffc11707566a0ea41"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/93/c4/d8fa5dfcfef8aa3144ce4cfe4a87a7428b9f78989d65e9b4aa0f0beda5a8/libarchive-c-4.0.tar.gz"
    sha256 "a5b41ade94ba58b198d778e68000f6b7de41da768de7140c984f71d7fa8416e5"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/f7/46/fecfd32c126d26c8dd5287095cad01356ec0a761205f0b9255998bff96d1/python-magic-0.4.25.tar.gz"
    sha256 "21f5f542aa0330f5c8a64442528542f6215c8e18d2466b399b0d9d39356d83fc"
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
