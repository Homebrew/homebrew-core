class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/48/46/da3f836a1236f8915c6daf8d92585b9cf78f8fd6f361a613cc38b34e21b4/diffoscope-180.tar.gz"
  sha256 "4969c9b2ee3e8a4f9151ec3c550d175f7936ab79f2f5c878688d4381b586326e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e9f0d75d831769be7477fd37419fe92b0709ca940b728b37e1f78839bb374546"
    sha256 cellar: :any_skip_relocation, big_sur:       "4978b076a6de8fd0ccadbb2f15c64cbe6655a308cade181b9667b2674c630215"
    sha256 cellar: :any_skip_relocation, catalina:      "317a78f19a5d6f705cc6f75a6d29d9b3eab663d661ee94eb7005e784af7ecd89"
    sha256 cellar: :any_skip_relocation, mojave:        "a6ceb6a6760964b88019dbafe8f000ad4eaec541cddc5b2c52ec0bd7b3296624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1279623cbddf0c727d4d4750fb84ed56ed8726a52ad8bc07bb67340d56a8f5e1"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.9"

  # Use resources from diffoscope[cmdline]
  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/53/d5/bee2190570a2b4c372a022f16ebfc2313ff717a023f277f5d6f9ebf281a2/libarchive-c-3.1.tar.gz"
    sha256 "618a7ecfbfb58ca15e11e3138d4a636498da3b6bc212811af158298530fbb87e"
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
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
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
