class Beancount < Formula
  include Language::Python::Virtualenv

  desc "Double-entry accounting tool that works on plain text files"
  homepage "https://beancount.github.io/"
  url "https://files.pythonhosted.org/packages/93/a6/973010277d08f95ba3c6f4685010fe00c6858a136ed357c7e797a0ccbc04/beancount-3.1.0.tar.gz"
  sha256 "1e70aba21fae648bc069452999d62c94c91edd7567f41697395c951be791ee0b"
  license "GPL-2.0-only"
  head "https://github.com/beancount/beancount.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39c80fbd4ff41b065982713794dc3c9a6f024c25b8ff7cb39ed28bda78d2ddf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a423e9224c67f96095e9e5a2663ffd285088315890be3689abf742db767dbc4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ed2293c7df4680ef507cb497ea9e4367912650e944510ed05083b95331f7b3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "39ff208f5f23b73eec9f15974f0e0e4165acf98b5927f1884e5b29cac1717277"
    sha256 cellar: :any_skip_relocation, ventura:       "5772e0476fcd2348f87e2a05236af991e27ac1a49445bee67a40ffa558aef8ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89bf5a7f146f0d41c9366c7a5465ae019a99af50ae801ee4d6d00b96e0c5c10c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c25a49250979c8840ef7feae60728d2d4f0653793719e66744266bdf499433d"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "certifi"
  depends_on "python@3.13"

  uses_from_macos "flex" => :build
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources

    bin.glob("bean-*") do |executable|
      generate_completions_from_executable(executable, shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
    end
  end

  test do
    (testpath/"example.ledger").write shell_output("#{bin}/bean-example").strip
    assert_empty shell_output("#{bin}/bean-check #{testpath}/example.ledger").strip
  end
end
