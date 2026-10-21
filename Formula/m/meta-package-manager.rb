class MetaPackageManager < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Wrapper around all package managers with a unifying CLI"
  homepage "https://kdeldycke.github.io/meta-package-manager/"
  url "https://files.pythonhosted.org/packages/26/09/a168bda8ef7bb8d66e13fbeecc3f9fdc09f6bb55f6b216b474780b90247b/meta_package_manager-8.1.2.tar.gz"
  sha256 "ceeb12d493e50101a46cfed6c999f3c8aff690b727b12b111f8a57d74cabd795"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/meta-package-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ec4504b89a822353e579072b787bde3ae703826cb1cbb39035766000dc4c83b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b9fa84ee92d438d7f788ee5b82256b6d3d2e1a5f0a8bf83ef6364082c09e219"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7cceedcbacdb2f5161c1550e7ff4624d127ecab43b31e1b25825b4ac2bda3cb3"
    sha256 cellar: :any,                 arm64_linux:       "e2d109ff72af99454ed54810acf83495d1ab902b21a6ec4d936bd191b078a04d"
    sha256 cellar: :any,                 x86_64_linux:      "3e379c46e3df33bcadba2925dd9f70db8c6eec7a8607ea1593039de65b842fe9"
  end

  depends_on "rust" => :build

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: ["certifi", "rpds-py"]

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/71/56/14c4a4931910a81ddeccfbe227925ea738e3c445d3e2af960f0bcbba1616/boltons-26.2.0.tar.gz"
    sha256 "d39cfd15c1a1c3bd4d705c82252fa9edb8e4f5e8cc039f8e39afac7b1b47e92c"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/e1/60/e2a6409041cb3f8ce7ac3d6917b5b30c39f81a0a5b2d414ec30f36fd96bf/bracex-3.1.tar.gz"
    sha256 "35c69fc105f08d77c02722e8ae707c656ff298dd4d26c89bcb3c98fca8bc3614"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/13/20/e2d60c90277a668b10a00f7a74cd52a87ab0c85afd5b8975cc582601eafc/click_extra-9.4.1.tar.gz"
    sha256 "065df41b1c8f6601bd9e550d79ac34a73ba40bfc84cfdb320cdcfe066c40a6d1"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/05/e2/d41446c6195eff0db3b671ddb202e39f42f9ea7c0dd15cd43fbf5cf0d7f7/cloup-4.0.0.tar.gz"
    sha256 "83b0870ee863bcc85129e40e1b208bcfdebe4cd2142e9ce1d0daf7d276cab038"
  end

  resource "deepmerge" do
    url "https://files.pythonhosted.org/packages/38/6e/5cb3548b4d3112fea529375e55e6f3cdc52b8054e3a66f203b1f888ba885/deepmerge-3.0.1.tar.gz"
    sha256 "35b39a4cb92cf328d6eca61cbbf65f68a37c2ceb3085f0f853cbb2e52a59fc23"
  end

  resource "extra-platforms" do
    url "https://files.pythonhosted.org/packages/2b/7e/b92eb5fe6c14b00c1469357622ee32e8b96ba8247b90b9da4cba3743ab32/extra_platforms-13.12.0.tar.gz"
    sha256 "883feefe546402e1ccfe6f53b3f248dbaee3cd72d82e137549769db452c4712c"
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
    url "https://files.pythonhosted.org/packages/78/cd/0e028d8b7d906d51acdac537334fbe85f8284f2a8147d48bc9403af77a0d/wcmatch-11.1.tar.gz"
    sha256 "f2b6f0fad6f5e2571498723fcb3c8facdd0fba0dcc139f31d32f592eb648153e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
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
