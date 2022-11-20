class Awslogs < Formula
  include Language::Python::Virtualenv

  desc "Simple command-line tool to read AWS CloudWatch logs"
  homepage "https://github.com/jorgebastida/awslogs"
  url "https://files.pythonhosted.org/packages/96/7b/20bff9839d6679e25d989f94ca4320466ec94f3441972aadaafbad50560f/awslogs-0.14.0.tar.gz"
  sha256 "1b249f87fa2adfae39b9867f3066ac00b9baf401f4783583ab28fcdea338f77e"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/jorgebastida/awslogs.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db940ee59609952b6e2251568f11647fd8e236a3c5ebf6b902798cd1a4a155be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf940e077956a855f8a7d7797528e258f4dc2aed6961b5d2cab8e1f11d8cd17c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32f93ee5842ab88a565f3795c028c8936bacef0a47c82e230a22578df6b1cc09"
    sha256 cellar: :any_skip_relocation, ventura:        "ecbc039cac8614452dc71876f048cd56b8b0142b68bcb10e3f6c914381b4c988"
    sha256 cellar: :any_skip_relocation, monterey:       "ec9e68210168ebc0a3b9c6bf2f66aaf20dfbeced69a943a5347023c0f962d3e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "86864dc46d4215e39f95392263d68fbbf8472bea835b350c86738f7b13e15219"
    sha256 cellar: :any_skip_relocation, catalina:       "13a4e491a27337b913f465c8582672936524455d6bb0a1cdb224866bc0bf89db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4f17d633effa2e90989f673a5cdd62607f95ec86609de92eb2ee06b008edcce"
  end

  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/df/e4/893fc4af6ee0c801725b48ba4d3120705126edab71e0fe84f8eb4850c427/boto3-1.26.4.tar.gz"
    sha256 "244fd0776fc1f69c3ed34f359db7a90a6108372486abc999ce8515a79bbfc86e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/32/c1/3a3cbbdc58a71c1dfafbeeb79dd09b68a030ff5c52df7ad8e87d5ed57c10/botocore-1.29.4.tar.gz"
    sha256 "fa86747f5092723c0dc7f201a48cdfac3ad8d03dd6cb7abc189abc708be43269"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/62/1a/e78a930f70dd576f2a7250a98263ac973a80d6f1a395d89328844881a0c0/termcolor-2.1.0.tar.gz"
    sha256 "b80df54667ce4f48c03fe35df194f052dc27a541ebbf2544e4d6b47b5d6949c4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awslogs --version 2>&1")
  end
end
