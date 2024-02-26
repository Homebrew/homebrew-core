class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/c6/97/655edc7d0264aa70289c86ef7aeb5306273d1bfffa04b67b16377dd24664/diffoscope-258.tar.gz"
  sha256 "392788664f470924c70429283deb7e5d91ff270df055477534747216dd62ed59"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c311d34cad95dd5f98fe5f92accff2694af6f2137b9e318d14842932d08ac1de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aeb65b55d0340b5ac4fb845786ebb3e36535d497659f3c7c808e3f0c1fd69c0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe08e4b644a49d492cf088c854cba2fb116f19e676362345e424ee54886cf1ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "42700d83c0ffbac2b4868c3f059f13f0735a4f2787b64c5b54489c9d0789856b"
    sha256 cellar: :any_skip_relocation, ventura:        "b523c3125de94f18fd8b89c58653889b8bf9438b37a96c8405fec84827e6de9d"
    sha256 cellar: :any_skip_relocation, monterey:       "2c15779286e101c5c260d3d2f367d6815e3a3083a5274324545515eca9a95c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43a9ea6ba1ef0975768275639d082e70f8c1bf98304a8367f36d161b8e9b1d90"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/f0/a2/ce706abe166457d5ef68fac3ffa6cf0f93580755b7d5f883c456e94fab7b/argcomplete-3.2.2.tar.gz"
    sha256 "f3e49e8ea59b4026ee29548e24488af46e30c9de57d48638e24f54a1ea1000a2"
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
