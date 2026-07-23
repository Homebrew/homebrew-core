class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/43/f6/bbab2a5af7fb7ef42f586f24a076fc320ad3dc4ed17549bb399e796700fa/diffoscope-325.tar.gz"
  sha256 "d74a2edb0555a9ee306d5362b921f80c144bb941c0a6d61794473d1540d729ad"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a72037bc49da01d52e50a7a8d65264b0a29453c3f3b1168dd383b2ca6911a13b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a72037bc49da01d52e50a7a8d65264b0a29453c3f3b1168dd383b2ca6911a13b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a72037bc49da01d52e50a7a8d65264b0a29453c3f3b1168dd383b2ca6911a13b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2db4f84637a2c1214ad915970444f8a574d3aa0000373b6d2a2860b2cfebd03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9916c6eb842216ce0bff58f20ec5aa2e9606685ccd9ea3f5fa5aa797d35810af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9916c6eb842216ce0bff58f20ec5aa2e9606685ccd9ea3f5fa5aa797d35810af"
  end

  depends_on "libarchive"
  depends_on "libmagic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages package_name: "diffoscope[cmdline]"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/95/c0/c8e94135e66fabf89a120d9b4b123fe6993506beca6c1938a74c24cfa5fd/argcomplete-3.7.0.tar.gz"
    sha256 "afde224f753f874807b1dc1414e883ab8fe0cda9c04807b6047dcb8e1ac23913"
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
