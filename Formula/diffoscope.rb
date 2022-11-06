class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/81/96/de99acd77690c3bc2213ad19de63f33413d5439cd1ef4b6f90111833cba5/diffoscope-226.tar.gz"
  sha256 "3dbdc5dccdc110b67cd57418e4d710397717c2652c833ba043787d83a8f60e1e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47129913a2f39310b1671c50ea1dcb0326dc460d23b87ee5ed43a88c25c8e8c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77468ad5a045fa93d961aeb11a7e2514adec1c960075f063f0169b1a511b8ae8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "553e95e0bc5b77d981734a8b907d6b99bf61f1552cf20c68c9db1d5b4bb4ef60"
    sha256 cellar: :any_skip_relocation, monterey:       "3c76d111a438c37024ccd47b2cb88b99ab070b6b1b20d5957b1da4c35154001c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b7a8a62ef0107615cf6d3121173f437da8fbed0629c6ad2b1b5d8ad5cde8caa"
    sha256 cellar: :any_skip_relocation, catalina:       "9d46ef2afed90c69c4bccfede7fab82621799c884b85b16b316acbaa16b230b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95e4251fade68c7a3809c9f88b745a6d12d8abba2d04e4c8cf3252fd18684f88"
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
