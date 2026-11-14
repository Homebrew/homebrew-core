class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/6a/6a/2d5bc334263a6a0a82814b28332a119d02f934ab6de50f66ce89b8fb5aca/diffoscope-339.tar.gz"
  sha256 "fb033492c16017963bfa04290c3ffd8e3b7884e1226dfaa6da2b1a07368d8e82"
  license "GPL-3.0-or-later"

  bottle do
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
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
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
