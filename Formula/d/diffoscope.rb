class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/05/07/4be45313866ff22dbcea60eefedeb16b654205840f911b510e7dbd994828/diffoscope-249.tar.gz"
  sha256 "bc4d8cb3198025013784ef7e3fa61b7a642de39e5b790c45d7c29d153306fbdd"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a91037412f6b95c422f73a88ce6ad386026f43a5eaf08ea20f7dc7b3daf615c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5797f116250f900f569300ec5eb58da8d03197cc1a8dd5ae8b6ddfa70314565"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "264bc133f205165a4f6df1ea129b62e0d4d30c0622c8077e1fe228cf85adda9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "550ccc7f4e88c1d6217ccad3a94718b13038515ea917b40354142b76262d620a"
    sha256 cellar: :any_skip_relocation, ventura:        "650461849a19d1b66dcd102a2134c464bc19279c04c663eab94696ac474d7478"
    sha256 cellar: :any_skip_relocation, monterey:       "8831f96576ef2beee2db20c796df7c2d8f9bc1fe38fbf6113cf3c6b81644fda4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9bdcc356e95510f56a794b1b4fd4a87122f657f366a004eb3d1ed3561bef7c7"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/1b/c5/fb934dda06057e182f8247b2b13a281552cf55ba2b8b4450f6e003d0469f/argcomplete-3.1.2.tar.gz"
    sha256 "d5d1e5efd41435260b8f85673b74ea2e883affcbec9f4230c582689e8e78251b"
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
