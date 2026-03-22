class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/c8/2d/d3d7939de818d999902c533828b3305ddb5d54ac351c0e080fe19adc40f1/diffoscope-315.tar.gz"
  sha256 "935cbf81f205d1de49dc3ba273d5169916d0081bc6c4db20d15913b30c82b9aa"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bffa7b0b68ac845661e30d593d3c52963e0e26d257d264a427904479b1b1be24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bffa7b0b68ac845661e30d593d3c52963e0e26d257d264a427904479b1b1be24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bffa7b0b68ac845661e30d593d3c52963e0e26d257d264a427904479b1b1be24"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d979ee555bebe609cfd270e06f0bca5fda0a69162be253cd52c6b0571c571f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58eee16cab6856b3cc6a20c1ad756acd769105f49ea6fd16197e9225aa36724a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58eee16cab6856b3cc6a20c1ad756acd769105f49ea6fd16197e9225aa36724a"
  end

  depends_on "libarchive"
  depends_on "libmagic" => :no_linkage
  depends_on "python@3.14"

  # pypi_packages package_name: "diffoscope[cmdline]"
  pypi_packages extra_packages: %w[argcomplete progressbar]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/26/23/e72434d5457c24113e0c22605cbf7dd806a2561294a335047f5aa8ddc1ca/libarchive_c-5.3.tar.gz"
    sha256 "5ddb42f1a245c927e7686545da77159859d5d4c6d00163c59daff4df314dae82"
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
    venv = virtualenv_create(libexec, "python3.14")
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
