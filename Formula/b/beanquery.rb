class Beanquery < Formula
  include Language::Python::Virtualenv

  desc "Customizable lightweight SQL query tool"
  homepage "https://github.com/beancount/beanquery"
  url "https://files.pythonhosted.org/packages/cd/04/8d9f3a48065fbf3f58826e8ea08bff35710ea8d542ed04654e87ec7b7b94/beanquery-0.1.0.tar.gz"
  sha256 "b69e099b8421b219bbcc3293af77e3c4ccad7ab25bf520fee48788672ffbf64a"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "524bcd44ee4459540ba85b770352970815ba18f6c08640ed18a72c47af45ee59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a0bcc22da5e37256f7ef397b382e85d7342613dafefa6dbeccfc191b91fc75f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63ddd18ec335a19f6b3f0e5fed1efdbd4c31f72d96ef328aa5c2aba910d0b8d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "be0d6cbc30bb9ac669951dcfd6186fb8a3541fcb47aae5950588bd9946ec3490"
    sha256 cellar: :any_skip_relocation, ventura:       "b92693ad9f3c86dd1f1ef62bea2f170bba9fe1b81f1dcc11fc4a905b88ce630a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f9b366199597258009dfbab13417889537343c76c7d8db6ec0d35129012844f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "beancount" do
    url "https://files.pythonhosted.org/packages/bb/0d/4bfa4e10c1dac42a8cf4bf43a7867b32b7779ff44272639b765a04b8553e/beancount-3.0.0.tar.gz"
    sha256 "cf6686869c7ea3eefc094ee13ed866bf5f7a2bb0c61e4d4f5df3e35f846cffdf"
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

  resource "tatsu" do
    url "https://files.pythonhosted.org/packages/09/f6/d53b45ea138e24199486e11deadedf06d0bedc9373911582b57a484f3d59/TatSu-5.7.4.zip"
    sha256 "ebd8212323328115bc4967db9a40d7f15b627db4663290c64e5ef8fe71dca0ae"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.beancount").write <<~EOS
      option "title" "Beanquery Test"
      2025-01-01 open Assets:Cash
      2025-01-02 * "Test Transaction"
        Assets:Cash          -10.00 USD
        Expenses:Test        10.00 USD
    EOS

    output = shell_output("#{bin}/bean-query test.beancount 'select account, sum(position)' --no-errors")

    assert_match "Assets:Cash", output
    assert_match "Expenses:Test", output
  end
end
