class Awslogs < Formula
  include Language::Python::Virtualenv

  desc "Simple command-line tool to read AWS CloudWatch logs"
  homepage "https://github.com/jorgebastida/awslogs"
  url "https://github.com/jorgebastida/awslogs/archive/0.11.0.tar.gz"
  sha256 "6258a121629cb872ee61fe78bf112753c8782c971524f0943a0e21f74d5e28bd"
  revision 2
  head "https://github.com/jorgebastida/awslogs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f830a44cb54fceac76e0588cc8cbc12ef61bce9fefde7395f6eaa8d459bfaf94" => :catalina
    sha256 "8dc15f74822ee782d470c17cda9796ab2859639382b6b85196fa95df1e0467c3" => :mojave
    sha256 "2adb8376393d9f0922bbe8938980d612995389d05794605cd565d4d4cf1874fc" => :high_sierra
  end

  depends_on "python@3.8"

  uses_from_macos "zlib"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/fd/50/3868735fae36e0f93216019551ca0f75b6cf9f933a55891244efefdcc3bd/boto3-1.9.62.tar.gz"
    sha256 "e9e93029b0d4f91ff342ffd953048c5a64e6a1522c2362c4521864bcc88cc365"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/da/c5/8fded95d8076d0144cbe3b836277ce234cee86e1b1393f6e6e8bedbf1436/botocore-1.12.62.tar.gz"
    sha256 "67ebafe2d0d6a37b62033bbc78786fdada02c38535f83d74313dc0dc281bf87d"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/76/53/e785891dce0e2f2b9f4b4ff5bc6062a53332ed28833c7afede841f46a5db/colorama-0.4.1.tar.gz"
    sha256 "05eed71e2e327246ad6b38c540c4a3117230b19679b875190486ddd2d721422d"
  end

  resource "crayons" do
    url "https://files.pythonhosted.org/packages/14/fa/635fdd47686a0f29692d927333fcf39e0279fc39c81704866c97adc34053/crayons-0.1.2.tar.gz"
    sha256 "5e17691605e564d63482067eb6327d01a584bbaf870beffd4456a3391bd8809d"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/e7/87/fc2ab653e628e2e51e00115bc9cb14c31afdd03acb710f137056a1c13f7c/dateparser-0.7.0.tar.gz"
    sha256 "940828183c937bcec530753211b70f673c0a9aab831e43273489b310538dff86"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"
    sha256 "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/0e/01/68747933e8d12263d41ce08119620d9a7e5eb72c876a3442257f74490da0/python-dateutil-2.7.5.tar.gz"
    sha256 "88f9287c0174266bb0d8cedd395cfba9c58e87e5ad86b2ce58859bc11be3cf02"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ca/a9/62f96decb1e309d6300ebe7eee9acfd7bccaeedd693794437005b9067b44/pytz-2018.5.tar.gz"
    sha256 "ffb9ef1de172603304d9d2819af6f5ece76f2e85ec10692a524dd876e72bf277"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/16/07/ee3e02770ed456a088b90da7c9b1e9aa227e3c956d37b845cef2aab93764/regex-2018.11.22.tar.gz"
    sha256 "79a6a60ed1ee3b12eb0e828c01d75e3b743af6616d69add6c2fde1d425a4ba3f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/9a/66/c6a5ae4dbbaf253bd662921b805e4972451a6d214d0dc9fb3300cb642320/s3transfer-0.1.13.tar.gz"
    sha256 "90dc18e028989c609146e241ea153250be451e05ecc0c2832565231dacdf59c1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/cb/89/e3687d3ed99bc882793f82634e9824e62499fdfdc4b1ae39e211c5b05017/tzlocal-1.5.1.tar.gz"
    sha256 "4ebeb848845ac898da6519b9b31879cf13b6626f7184c496037b818e238f2c4e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz"
    sha256 "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awslogs --version 2>&1")
  end
end
