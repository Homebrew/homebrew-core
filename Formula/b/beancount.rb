class Beancount < Formula
  include Language::Python::Virtualenv

  desc "Double-entry accounting tool that works on plain text files"
  homepage "https://beancount.github.io/"
  url "https://files.pythonhosted.org/packages/eb/21/ed48e671a5e474c620762a7ea9c6b7f402f847d74dd2b73ceb5d2dec79a3/beancount-3.2.3.tar.gz"
  sha256 "f52c4d237bcb092cbf02a29373d3e59d95349c2828a91491818ae437ee220f74"
  license "GPL-2.0-only"
  head "https://github.com/beancount/beancount.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b0b3eb9f36172bb24d47c4cf5dab4e9c80fa0936bd0f0af8259c7cdc8f7d230"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec082b6f85cae519441872adcc0994f9edb34328983e2bd62ead3aacd230772f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eaa20c160d875fdf69dca36a92ba1325baeb273e7bf25b6f32fa304313fad941"
    sha256 cellar: :any,                 arm64_linux:       "1aeef6039ddc1169a567e9beab060084a3fecbef0d0bc506a66f8ff91d0ca76a"
    sha256 cellar: :any,                 x86_64_linux:      "cc85fbff9d255ffd8b9c69e367bfc030bae541b230daf2ac51b28761ba9f8edd"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "certifi"
  depends_on "python@3.15"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: "certifi"

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    # Skip the PyPI flex/bison wrappers; we already provide system equivalents.
    inreplace "pyproject.toml", /^\s*'(flex|bison)-bin.*\n/, ""

    virtualenv_install_with_resources

    bin.glob("bean-*") do |executable|
      generate_completions_from_executable(executable, shell_parameter_format: :click)
    end
  end

  test do
    (testpath/"example.ledger").write shell_output("#{bin}/bean-example").strip
    assert_empty shell_output("#{bin}/bean-check #{testpath}/example.ledger").strip
  end
end
