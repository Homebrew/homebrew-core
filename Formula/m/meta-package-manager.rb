class MetaPackageManager < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Wrapper around all package managers with a unifying CLI"
  homepage "https://kdeldycke.github.io/meta-package-manager/"
  url "https://files.pythonhosted.org/packages/6d/c2/3978debb7dbca4c6f2a90732bffb4b7c62141a6d6b3d9c9ea54fab060a41/meta_package_manager-7.3.0.tar.gz"
  sha256 "f540a4957ae2d3f702e97aa3217261b808e4b98233707c9f8c5f214c3dbfee91"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/meta-package-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d3140aca5b0fcbb2a4c0a8a542e647bfdf0360e8795d28dedf4fbfd768c8ce6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d3140aca5b0fcbb2a4c0a8a542e647bfdf0360e8795d28dedf4fbfd768c8ce6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d3140aca5b0fcbb2a4c0a8a542e647bfdf0360e8795d28dedf4fbfd768c8ce6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b371d3f7fc8edbc8147fa7c6c83ea27d75846a5ae2b9b040323cbe957f6630ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4df75c2fae811f87d60a8c7cc04d974e085b6b1a73d8fc22c1a8bcd8efdb1156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4df75c2fae811f87d60a8c7cc04d974e085b6b1a73d8fc22c1a8bcd8efdb1156"
  end

  depends_on "rust" => :build

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: ["certifi", "rpds-py"]

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/7a/1f/60df922ae497d838c58b48caa518251e2c8e228d7fe93792fee69a3858d6/boltons-26.0.0.tar.gz"
    sha256 "5566d6cfd5a1e873d8e8476496287a9f92979964611ad9a9cecb6b0ef29b1edd"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/d0/f5/4473ad9b48cd0420a2d762a3750fa0e078e23e060b1af72662e5987e5530/bracex-3.0.tar.gz"
    sha256 "b73f718d6bd98d8419e45df02426c86e9967c179949f779340d6c3a8c83b9111"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/9a/78/ff052a35e7b83a1b164e1eda3a5bdeedceeb60e44d2eca1d872312447cee/click_extra-8.4.0.tar.gz"
    sha256 "92e5441824126248c61b05471ecacb6403e45a0b0b743f6babf425abb4c217de"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/42/ca/cf02e965cfeb70d65c61fd3abb8022aaf5111a0de71b3c73a6ec2113aa25/cloup-3.1.0.tar.gz"
    sha256 "637c1e628fe98f3f20a5e44da591a72b42bf54d7d4527190bf39ed5f64af7585"
  end

  resource "deepmerge" do
    url "https://files.pythonhosted.org/packages/2a/78/6e9e20106224083cfb817d2d3c26e80e72258d617b616721a169b87081e0/deepmerge-2.1.0.tar.gz"
    sha256 "07ca7a7b8935df596c512fa8161877c0487ac61f691c07766e7d71d2b23bdd2f"
  end

  resource "extra-platforms" do
    url "https://files.pythonhosted.org/packages/77/c5/fae67f4681a664ad855b0cc219b89459f2144e144966b56abc2c63af2921/extra_platforms-13.3.1.tar.gz"
    sha256 "1efefa780f0b97dce5d352f7873065988f7f23938af70456182b20474849d1c2"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/f5/d6/3b5a4e3cfaef7a53869a26ceb034d1ff5e5c27c814ce77260a96d50ab7bb/packageurl_python-0.17.6.tar.gz"
    sha256 "1252ce3a102372ca6f86eb968e16f9014c4ba511c5c37d95a7f023e2ca6e5c25"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/16/25/1da725838132221e33568973da484ff43813662ccc06ebf7f6e3abddfcd5/wcmatch-11.0.tar.gz"
    sha256 "55d95c2447789712774b198ceec72939e88b5618f1f8f0a9b605bf7740b63b96"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  def install
    rewrite_shebang detected_python_shebang, "meta_package_manager/bar_plugin.py"
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"mpm", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpm --version")

    # Check mpm is detecting brew and report it as a manager in a table row.
    assert_match "brew,Homebrew Formulae,✓,✓",
      shell_output("#{bin}/mpm --table-format csv --all-managers managers")
    # Check mpm is reporting itself as installed via brew in a table row.
    assert_match "meta-package-manager,,brew,#{version}", shell_output("#{bin}/mpm --table-format csv installed")
  end
end
