class Beancount < Formula
  include Language::Python::Virtualenv

  desc "Double-entry accounting tool that works on plain text files"
  homepage "https://beancount.github.io/"
  url "https://files.pythonhosted.org/packages/eb/21/ed48e671a5e474c620762a7ea9c6b7f402f847d74dd2b73ceb5d2dec79a3/beancount-3.2.3.tar.gz"
  sha256 "f52c4d237bcb092cbf02a29373d3e59d95349c2828a91491818ae437ee220f74"
  license "GPL-2.0-only"
  head "https://github.com/beancount/beancount.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1af0f9a89d47e99664b9bad0e4d2751d478e174b8bc7cbd588ff6989383c00c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c57d3813a14d22f1a692b91998be9b172c289a6cf663eb95b17a392580cb9e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab88e4520e81e3e9522b763443cfa5a13eaa0f88f8f5fdea048f8e60da427f93"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c4062e64e6e41b696552c21225773e0f8754cb7a18c8e1662e8e0b083ef3ced"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4c4f66f5d218bb6526476e7c1fc8b1a5491e5e895957af55a8c1ad7bb92e471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5111dd091e70b372535c34ccec7b32356031a49473c679a47463e961e7ed6f3b"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "certifi"
  depends_on "python@3.14"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: "certifi"

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cb/0e/3a246dbf05666918bd3664d9d787f84a9108f6f43cc953a077e4a7dfdb7e/regex-2026.4.4.tar.gz"
    sha256 "e08270659717f6973523ce3afbafa53515c4dc5dcad637dc215b6fd50f689423"
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
