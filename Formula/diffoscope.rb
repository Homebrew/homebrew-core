class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/54/e2/d4b3b45648b94877e5d5676b2e6d8d091bbd8e08b49add8a0dc8fc03e314/diffoscope-234.tar.gz"
  sha256 "6091d555bc88ceca285dc40e63df56b57385aa0dc552daa70bde81e8a69f8c7a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17af0831e8c3797d4ca63bdc808328b3d22db528c6fff335d439991436e4263d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "029907280c35b99073ed3712d063e058b0a67ab76dfe3f18646fc30a41469a13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1e2622190a63aa545e181dd399a5457defe2c9aca0b6869cb3df1dcf7caa5ea"
    sha256 cellar: :any_skip_relocation, ventura:        "30be45f68ed257c381cbcb73bd7be0acc28b9fe818a23673b2b38aeb36a1b066"
    sha256 cellar: :any_skip_relocation, monterey:       "f1f008490a7dc360f08cb7930c6f14e1a2b05357593a0c39a7a0a80e40df6930"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2e977f2ce2037f617c68b83d4061fe3d760a17b932040484826b5bfaf10af9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83c44e35af8911b0b0c95f6449e5f37cac6fe4d6409f778b16b224ae7b774b49"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.11"

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
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
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
