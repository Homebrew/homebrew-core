class Beancount < Formula
  include Language::Python::Virtualenv

  desc "Double-entry accounting tool that works on plain text files"
  homepage "https://beancount.github.io/"
  url "https://files.pythonhosted.org/packages/93/a6/973010277d08f95ba3c6f4685010fe00c6858a136ed357c7e797a0ccbc04/beancount-3.1.0.tar.gz"
  sha256 "1e70aba21fae648bc069452999d62c94c91edd7567f41697395c951be791ee0b"
  license "GPL-2.0-only"
  head "https://github.com/beancount/beancount.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dc1fcd7f2317ea72784d7fbf2f76c54e2db0326d7526f22a1b9a9c291efc222"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a4c201840e45d79de983afd1068d188f3bc8d55d6d45f7cb2bb3434920f1e77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea4e49c721b56ee17b5c3cb7adbf37427f73beb5feb9dba8b96319f2c15e6a00"
    sha256 cellar: :any_skip_relocation, sonoma:        "c87741dafbf02e62986b0fa4b485542bb2f1e8cbc2d8f967475e94d46058c6a9"
    sha256 cellar: :any_skip_relocation, ventura:       "0417cdbffbbb58e14ed1f6496f390da38ffddf7f43483206ae61ceb97dff809b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b9d0b7dd0cbb81adba41b95cf6f87bd7810d5236d087c884c2398fdfffefba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f61124a05787d02519432086cbbbafef2b979e40747d7e9801559d81b0b1003f"
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
      generate_completions_from_executable(executable, shells: [:fish, :zsh], shell_parameter_format: :click)
    end
  end

  test do
    (testpath/"example.ledger").write shell_output("#{bin}/bean-example").strip
    assert_empty shell_output("#{bin}/bean-check #{testpath}/example.ledger").strip
  end
end
