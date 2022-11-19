class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/99/81/7feff6dd079b9515c33fa29c8ab627c43a554c9ab913454861dbdff8d0bc/diffoscope-227.tar.gz"
  sha256 "0727b64dd78254e4e53beb2d2541b4f0933b601fa4ca34960d0c9abae5cbb6a9"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4b96fbf24d66e262e97e29d9837c333ded1a91d0dfe152ce521d60c5077a52f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf65a08ca0fc72094bb914717eb8fac84cbf4602c2bc4c10f3e9e5995efbe797"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caca7515735196cb2656d52f80ee98b23c8dcd05d2d0d1939704e850c8c00fb3"
    sha256 cellar: :any_skip_relocation, monterey:       "7f0d1e61aeccd3eab6a602cf7016400da888304668aa2417d6bbd517bc22bb9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4963f34178922b1bde49ad928029a113253dfff9b515d7399209ba25017baaff"
    sha256 cellar: :any_skip_relocation, catalina:       "f0a3c43238fd61e62acf774bda343f611dd02fbeaa7bf30ef924977323ebd873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3942fd036bc5ac9791b70116ea414563c92e6b9bbc2c0e3e8313d05c58a4fae1"
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
