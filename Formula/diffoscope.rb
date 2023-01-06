class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/d8/09/5a5c7a480342f2c8a600bf69199a0d2cb78ae785bff7a293d28581ca61c4/diffoscope-231.tar.gz"
  sha256 "f08cddd1eb8312f196489a575d65e63ed00e17cb778f3934f8397b10f9d02d4b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ceaad1724f67f1b98293d4e6dde44d4005d7fe126fc5e56cb436206aaf11b275"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94cb7eeafbd57b57a2929c27a721046103ff2a7610c67ce96674e42ef3069dd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1367ed76c091c7c9ad9190fa8319e13a50c615c06d93c0645e44d02ce94fe36"
    sha256 cellar: :any_skip_relocation, ventura:        "90dd1345105e637d16ae68072ab13744ab27ac4fc0aede6dd075e7da302aa0bf"
    sha256 cellar: :any_skip_relocation, monterey:       "5f0f5f0c506ebef92a553a12b804b065e18d896d9e7d52f86e0c206d6c2450a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a3d1382300403e88e3f79bb2d261960ba954e193ab53c278120ac84f4e8fee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "284c9e83aa618c0c1d5f4a4b82f7c177628f00ece052823497af081397e87274"
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
