class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/a8/98/4533cadef42a19537e901593990bd781f957ded5bf3993f4a5a83ea712e1/diffoscope-198.tar.gz"
  sha256 "86b0bebf6750774075be67e7039a22abe05fdcac4214565d1a66c5cacc7448c7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03e74a3f577440cf783694e3d882a30a9720afefae7906328d57b31bf9c74e8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d4146d5126aa9fe60b190808534340071c915b35683ce62cc63cfcefa8d56aa"
    sha256 cellar: :any_skip_relocation, monterey:       "64534ba4d79e149a1fb2e5c07de0bd5cb9efbebd2fcd2193ecb376539863cbf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4397d651d13d03409526950e52acd4835895f6f6e75783094b602efce26b158c"
    sha256 cellar: :any_skip_relocation, catalina:       "108dee76d17396f558216996d301d64b1d9933b9a1bbc7b891c2d6085f0ba5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ebc4d5c659bded835b4a302d3d940866f55ae1a894a6e7a4477108da6d5415c"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/0c/91/bf5e8861ab011752fd9f2680ffd9a130cd3990badc722f0e020da2646c28/libarchive-c-3.2.tar.gz"
    sha256 "21ad493f4628972fc82440bff54c834a9fbe13be3893037a4bad332b9ee741e5"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/3a/70/76b185393fecf78f81c12f9dc7b1df814df785f6acb545fc92b016e75a7e/python-magic-0.4.24.tar.gz"
    sha256 "de800df9fb50f8ec5974761054a708af6e4246b03b4bdaee993f948947b0ebcf"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "--progress", "test1", "test2"
  end
end
