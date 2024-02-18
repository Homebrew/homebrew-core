class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/32/16/c9b164d6f5d7ec710a9ab0ecc111ecf6d281f124fa47eebf86acc233f973/diffoscope-257.tar.gz"
  sha256 "1bceee9ca6fe2d7faa2f21daf9f4a83d83e1f1be8b682691b1d985d5e870077f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7afed011c6976a2dc89be926c78446a5798588774ab460ffdfc4a7056cc18dd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c45c0a61bee3babebeb18210d15d08d07bcdf8f4af5696d6ec00215d219f117b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb3fc1b72a0d6f7a40d678f56f89def993230b72e6a38aa40de070ed1b98621c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2f9b3d247fd806e1f40971ae3c13a053f3569a39f3b1f24ae4ab04328b1829a"
    sha256 cellar: :any_skip_relocation, ventura:        "18f39eb56b4ec619b673f1c16c7ff529d8fc1e433934d6a217c983e510f1fd4c"
    sha256 cellar: :any_skip_relocation, monterey:       "eaeaf021c18a11d67668e2d3a565024f07a9394d94272b70e6a22cb5e812ace7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5668dbbcb1652ac1fa5ddeeb86d9bb0fb20821594fc3b443c926653cf121922"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python-argcomplete"
  depends_on "python@3.12"

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/59/d6/eab966f12b33a97c78d319c38a38105b3f843cf7d79300650b7ac8c9d349/libarchive-c-5.0.tar.gz"
    sha256 "d673f56673d87ec740d1a328fa205cafad1d60f5daca4685594deb039d32b159"
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
    venv = virtualenv_create(libexec, "python3.12")
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
