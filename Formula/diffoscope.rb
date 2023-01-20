class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/69/8c/9e91d8de0e110f711a85a15c1f875c9b2185f673d419013e92872e922eaa/diffoscope-233.tar.gz"
  sha256 "cb63f574846d4e5cb30bf47c1d3c1e735729ae9e3aaaceeb30dfbddc1ae8cbf1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec0495028144e66092f999aee96c43276dfa4ba87461a367b79c1e95a3b7487d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "835fb717b6c1d00fe71aadf6fe6c3137214c0fb1efb270d1a04657f9adaeb458"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fb79cf0dc07e8177fec08cd5dfaf48a5ec6ba57b33c419107081ef69a5d65a1"
    sha256 cellar: :any_skip_relocation, ventura:        "1599bfef0fb771dc1c40a509eee7382ef266f9858ea1a40c9881902c699566fb"
    sha256 cellar: :any_skip_relocation, monterey:       "fed6398db014919f7be231ee592cab715e36f24e23dd66e5f39af8758110904a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b7f55b82feea36e2bb066dc2cc9d7ccb1c4a1aa77a60a6fdc1def422e221248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95589bf00a3dfa676485bc157d4919ee283af824165e061e331b9ab1cf705d6e"
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
