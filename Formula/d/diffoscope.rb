class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/e7/fc/aa322d4b3d872333ddd313e2efdfb98777843f9b842a3192c1acf217f9af/diffoscope-340.tar.gz"
  sha256 "970a7858f78a45b1333091984bb2c5a59ef6f661be9cf06c5bea758a69696bcc"
  license "GPL-3.0-or-later"

  bottle do
    manifest_sha256 "8b4efde063422e4c89c65f43d4be945ac8ccc86482ffb7b78c37553789bb62ad"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9605942e6354d55ea17fd57c9dd2169586a8f90f43d64f13b9df6e83d3fb93c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9605942e6354d55ea17fd57c9dd2169586a8f90f43d64f13b9df6e83d3fb93c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9605942e6354d55ea17fd57c9dd2169586a8f90f43d64f13b9df6e83d3fb93c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "34d349380814a51e51a8bd909cc3b1d5aedfed0ce6eab06eef0175dbc6c83560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "34d349380814a51e51a8bd909cc3b1d5aedfed0ce6eab06eef0175dbc6c83560"
  end

  depends_on "libarchive"
  depends_on "libmagic" => :no_linkage
  depends_on "python@3.15"

  pypi_packages package_name: "diffoscope[cmdline]"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/19/0d/ca63f1b8b706c70590d0a4acc9c3c94ea8ed4dd9c83b4f7af195868abe76/argcomplete-3.8.0.tar.gz"
    sha256 "0114d634013e11ac92cc329b3a7d886c3506e98ddc7bb23c99b1782aacc8b8bd"
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
    venv = virtualenv_create(libexec, python3)
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
