class Hapless < Formula
  include Language::Python::Virtualenv

  desc "Run and manage background processes"
  homepage "https://bmwant.link/hapless-easily-run-and-manage-background-processes/"
  url "https://files.pythonhosted.org/packages/2c/ab/a5c875f00927421371c9c36849030ba84dc171e7157575fd85126e893064/hapless-0.15.1.tar.gz"
  sha256 "b54707a5f77ac8e779bfd0c8c49344333e9d40a5c9479f0da1c303ffa237077d"
  license "MIT"
  revision 2
  head "https://github.com/bmwant/hapless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da08ce56df28a0ba4aa5961303408a30758de532b674167a91f6d50680b6d42e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16845ee1b8f397956dfce79cbbfd516b58fa61e2ca8f55be7dc0e0d1dffcd213"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85328d7dceb3952ba09e22c44aef001be74ff872bd9093fcba2073a59a781ac6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd43290de50a062a326d1d7a9611b925e55de3801ce4321aa02cf9f3ab9343ff"
    sha256 cellar: :any,                 arm64_linux:   "5f4e5702112637ee2a46ceda8afaab4668b95aaad8142abe944a8f03e0992fec"
    sha256 cellar: :any,                 x86_64_linux:  "e4b3986d718dbdec80fbf1a128d2862b6fe44fae40f12f17c561afd238261251"
  end

  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "django-environ" do
    url "https://files.pythonhosted.org/packages/d4/3c/b2de27581c28929e3b33c5797e3d075c93541b4a8499ddc84dfd659d550f/django_environ-0.12.1.tar.gz"
    sha256 "22859c6e905ab7637fa3348d1787543bb4492f38d761104a3ce0519b7b752845"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0a/ea/13a1ef3c12d12662905801495283530251918b70d62d368f1d2e0272c70d/humanize-4.16.0.tar.gz"
    sha256 "7dc2244a2f84a4bfb1d36c37bac80cd78e35cdc5c119206d87b018e1445f3a3f"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/1f/5a/07871137bb752428aa4b659f910b399ba6f291156bdea939be3e96cae7cb/psutil-6.1.1.tar.gz"
    sha256 "cf8496728c18f2d0b45198f06895be52f36611711746b7f30c464b422b50e2f5"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/ef/52/9ba0f43b686e7f3ddfeaa78ac3af750292662284b3661e91ad5494f21dbc/structlog-25.5.0.tar.gz"
    sha256 "098522a3bebed9153d4570c6d0288abf80a031dfdb2048d59a49e9dc2190fc98"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"hap", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hap --version")

    output = shell_output("#{bin}/hap status")
    assert_match "No haps are currently running", output
  end
end
