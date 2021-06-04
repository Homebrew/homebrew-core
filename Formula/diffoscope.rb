class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/a3/43/77f45fd6fe16912607c6afeb37dad232a5db7719f4939f69640db52180fc/diffoscope-177.tar.gz"
  sha256 "8ac0cad150914bab2a53caa3f21876a78b092f3d2a36b9134874cd5c04a26b2e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cae4d0646d47ecc683ed2c30f468d9a4b670995d53f17e794745d026ba569b6d"
    sha256 cellar: :any_skip_relocation, big_sur:       "e641de0f2b93c6bef7502649883ffd76731ad4945b18ea0d12986d0b3d92f28f"
    sha256 cellar: :any_skip_relocation, catalina:      "9c3b865c6f0fab34233b384efb700a80413fdd2a5ce08267bd53dd499b15452e"
    sha256 cellar: :any_skip_relocation, mojave:        "a0e4d961da1e2e35da3e28ff6c03bd98fe998bfe8638aa9b916d65e6e7da98b0"
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
