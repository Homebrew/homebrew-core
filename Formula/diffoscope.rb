class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/86/45/ce379e171c487500b821fba4bfb831f6f6b6c3d44955e69087e16cd9b756/diffoscope-195.tar.gz"
  sha256 "192703fa4be756c45794ad338e94be5790e041f39f9f687560b2d01e9996576c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a22d64fffe0c23bafbdba08fdfb58d9284aeca620de033fc80ca24bcf8bf48e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65644cde3a91aae9fe8faa73b0b243ec235f8341661d26e1702e26d96f4b419f"
    sha256 cellar: :any_skip_relocation, monterey:       "1979ed775e4dce5986db21a8965d75ddd3c1fcf46421abd68d43db8e750fbcb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a2a06ee22cfffebf35cbbf42e777976f5aa4f5dc70e3a32c2e1c0d8a6b50d39"
    sha256 cellar: :any_skip_relocation, catalina:       "8501ecdb742c30b64aa504146b5384229a55c942372ba8a4f24bcb79877feb9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13a52c0feea637201cd02d44fd440ee29ce521ee3d343a33e9aa418ee080f1ab"
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
