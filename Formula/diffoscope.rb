class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/e0/fb/73544a66d4d404a97d04d283b7ef3e6bcb9e11753033bc9260926741a003/diffoscope-238.tar.gz"
  sha256 "b8cac5bf1750b6950bbb73084b5ff07a85ba5961f50ef72388f9f7db73c700e8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb1394a050b6f5c090f27600af844a3aa4f79e3732acba0d3418774e8c7ec3c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "072f48a8fa3aaf14d403af181287c562f1be7999206c01c035fbd0a81f392a34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fbf244755f6187a8cd8fff3d5bf1899d4e2de004dc409368136e675d2854da9"
    sha256 cellar: :any_skip_relocation, ventura:        "3f0daa0a7a42f3f524c0af15902e112e8986b47cf4cd0ae8fb490b2262382e18"
    sha256 cellar: :any_skip_relocation, monterey:       "829ac42c4585f3c4b7d79784d8fd71ff3e813655cd381768389a556a38181661"
    sha256 cellar: :any_skip_relocation, big_sur:        "246cbf066a1a61286992d6f04ee1134ae1c37ec5df3698e9270552ad76d0154c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5561cf52880cd4fb1631b884ce8ba0a8a8b87cc2dbecaea05c798606d89c08e8"
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
