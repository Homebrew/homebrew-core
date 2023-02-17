class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/4f/00/ef3a4e14afc05e6ae9dc0d273ae15807a03216cc70cae6326b0f9c3694ee/diffoscope-236.tar.gz"
  sha256 "84c46840dafffe0223056718e4250ceb52484452a992b85e345e3cf8a2cf7d4b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e190fbeb5aaf16a96ce551acdfec087d7d40da7ca861a6e982f969377ce538f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5389d1a06f21752a24cc3dde311e0b96f6e4bc88e935a1c537e01c5b9b88844f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06ff7692a75e3895ce7fb72bbe2c2661dc2ebc885d7a81a84c98ca12d6b9caa4"
    sha256 cellar: :any_skip_relocation, ventura:        "c17644271740d146adef6a5f335c95a609c8e5ff1d1a0b33f898dd5e36d1e8aa"
    sha256 cellar: :any_skip_relocation, monterey:       "69ebb44894a568db32f50f2640d80f3fe0ed4fb702d17b0f9fdb6d66ef93d3a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e16ea4561f82e0478547f89606263781c5a990dfc86ed2bf668da92ba7fc8d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0488ef7629b7e9ed37933bde0b3719a9fb6091bdb1b183bbeed633b7ad8b8e9"
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
