class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/05/07/4be45313866ff22dbcea60eefedeb16b654205840f911b510e7dbd994828/diffoscope-249.tar.gz"
  sha256 "bc4d8cb3198025013784ef7e3fa61b7a642de39e5b790c45d7c29d153306fbdd"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbcceb829663827b2af3afbef5bfaca36590aaca71d0804309d8455feb7b61b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "875c49a37657ef27ce9cac8abb65a2aa42c3dadd740645fb90ee81892b7e432d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbe25562de9dcaf7e5dcf90bfad81e77f8ed5029703bea7ad4a5f03bba581dd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca3eda24fa2e7ecfabe34f4daffe52b78187a6493e5fa1932dc2e6b9f72e02f3"
    sha256 cellar: :any_skip_relocation, ventura:        "c68ef7172f3eb38b85323b29b14f6c62c090255f8b0dde8c153c8a1949f3b9c1"
    sha256 cellar: :any_skip_relocation, monterey:       "605795f64c1b361dfb3ca99380fc71c26f25d74cbc507a5d0b4c08cbb893e77b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8def66782572fc3e5c7847b924ae43e401336dd14a0873c5f4e0ca3012c5c017"
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
