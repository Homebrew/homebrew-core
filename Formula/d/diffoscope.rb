class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/2f/ee/899ee910929964d2ce45c544a9b076470523881653100d694215fc930123/diffoscope-321.tar.gz"
  sha256 "334ed39f13f92a1ffad5018a4038a88dacc4a287996601082d8af4428e1f0493"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a92a6192dbbeb048205e5a8af8c4538dfda823a9861aaee8bba94c4b8380fd4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a92a6192dbbeb048205e5a8af8c4538dfda823a9861aaee8bba94c4b8380fd4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a92a6192dbbeb048205e5a8af8c4538dfda823a9861aaee8bba94c4b8380fd4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "422c7380fa3af339793d79e934bbd6e04bfe162b70617851d45be88a6998e316"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bb9aaed3ccb4b11abbd29d386e3a5d0d33fdbf33943e07cf421d5bdcff984d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bb9aaed3ccb4b11abbd29d386e3a5d0d33fdbf33943e07cf421d5bdcff984d6"
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
    libarchive = formula_opt_lib("libarchive")/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system bin/"diffoscope", "--progress", "test1", "test2"
  end
end
