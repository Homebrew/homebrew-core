class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/61/76/bfb524f4752a30051b2a27ae4b7717f1410e09377956c89a101c5813b1c1/diffoscope-224.tar.gz"
  sha256 "1920ebdca40e85f019a84e0220e4a79f00ffdafc0f78e1f1e2219123d5c08dfb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e389e3a768e709c7f5ff2ffdf5f613391409aea89229f3f1de08f5398015a48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e24a1f969b79c473773ee52e0fc9bb13b84c148bcc9491b0d97a66271a853c24"
    sha256 cellar: :any_skip_relocation, monterey:       "bc632c028907f3293887dfc76812f1818cf1cc675dfb1eca5ef0b40eeea950f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8e33839e9e29294a60b512f8ea99fcfeb800ff9e45bc806e41623bfcf2359c7"
    sha256 cellar: :any_skip_relocation, catalina:       "7632665ebfcf94486e9184bec746e55d0b4254a0a50ccb46e0b2402a19545cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4802171bcc615e91b5d7be8962e4af4cc9d0f0dfb0160c592a01214d2d4aa19"
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
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")
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
