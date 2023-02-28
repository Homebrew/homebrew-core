class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/6c/fd/752f4bb9fa7971c81d69a615bc92c9ffd4526c0848398ed12b40ce4997e9/diffoscope-237.tar.gz"
  sha256 "9ade0c8e43fc6edd89fe7c3c1bd5020d0cf6ec44fd120c7e3b887ebbee588a35"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "301daccc54f68963eacff759471241cb0f45aca9b2c6333f898226a221a56053"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "594108eb62629b14f88de030add85ae4e4c7efe8c32c26166d967ac59f25273e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dd9b0f2a485a9da58b15f2d14059fd719c1960c16f0194ae133323162f1c565"
    sha256 cellar: :any_skip_relocation, ventura:        "487d940bccdc57fec806b71b493c360eae944d5b69ade49e7e2557727c939be5"
    sha256 cellar: :any_skip_relocation, monterey:       "116828a199b5ad296632e1b2e9b6428a18297f697eab5a7eb1466717db63bd83"
    sha256 cellar: :any_skip_relocation, big_sur:        "69ba6d7d302813f77955cf239262e310d578540c12fdc521f4d31a2bc956026b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "131dc9b77e7d8b468165da98b90838a48ef4050f382085d356509b1f7bc49656"
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
