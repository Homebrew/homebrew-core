class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/05/07/4be45313866ff22dbcea60eefedeb16b654205840f911b510e7dbd994828/diffoscope-249.tar.gz"
  sha256 "bc4d8cb3198025013784ef7e3fa61b7a642de39e5b790c45d7c29d153306fbdd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0e72909b5016d51ee3cbf0ed2c9e988991d149b5ea7a2bb31fc451cdccb838c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a596e126c3c662b920f1a9150fd0b3bb606d12972bd6247eebfa27a50e0d4478"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a744ce71d0b906567a8c900443c12507f92de107f66ff4129c56bd46a523c54e"
    sha256 cellar: :any_skip_relocation, ventura:        "d2e9a11b0c94e882bd89bc0464a3db75975f52f495974ab50ee9d4d86f1b7001"
    sha256 cellar: :any_skip_relocation, monterey:       "af82aeb3e9865a6e918a902baad652306639e72c40186a452c77010402a088b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "47f979be4155f860cc2ca4564ea7ae74e2d85ebb2d597d8c829101f504dedd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "142ce52ed51c1e4b6107d8c6219d7bce31f32b31842b76f9222014b8a926c3e1"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/54/c9/41c4dfde7623e053cbc37ac8bc7ca03b28093748340871d4e7f1630780c4/argcomplete-3.1.1.tar.gz"
    sha256 "6c4c563f14f01440aaffa3eae13441c5db2357b5eec639abe7c0b15334627dff"
  end

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
