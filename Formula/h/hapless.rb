class Hapless < Formula
  include Language::Python::Virtualenv

  desc "Run and manage background processes"
  homepage "https://bmwant.link/hapless-easily-run-and-manage-background-processes/"
  url "https://files.pythonhosted.org/packages/2c/ab/a5c875f00927421371c9c36849030ba84dc171e7157575fd85126e893064/hapless-0.15.1.tar.gz"
  sha256 "b54707a5f77ac8e779bfd0c8c49344333e9d40a5c9479f0da1c303ffa237077d"
  license "MIT"
  revision 1
  head "https://github.com/bmwant/hapless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f169b0818ad25ef07114e116e4e9334c44bb4ff0e5eccc13aae728e3a17e53e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e57876a959e0ac43420f19167686995a7c451141ab243639d6828c84d0f89ba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81d714d9e2ca4ccc878aec973c7b60e32676e9c28ad87b82ef334367de09a399"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab3e595aee0267253ee8d84c95cb0795b74b7519ac5ceb037b5aa2c58c470d89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba7b3f19bfa985154140df5a871ff98be1ff56db3d410a6a03fcb49462758984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45c8d4794f6121888e0c65e1e3c53ebc8137de42368ac378e297fec15ad965e"
  end

  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "django-environ" do
    url "https://files.pythonhosted.org/packages/d4/3c/b2de27581c28929e3b33c5797e3d075c93541b4a8499ddc84dfd659d550f/django_environ-0.12.1.tar.gz"
    sha256 "22859c6e905ab7637fa3348d1787543bb4492f38d761104a3ce0519b7b752845"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/ba/66/a3921783d54be8a6870ac4ccffcd15c4dc0dd7fcce51c6d63b8c63935276/humanize-4.15.0.tar.gz"
    sha256 "1dd098483eb1c7ee8e32eb2e99ad1910baefa4b75c3aff3a82f4d78688993b10"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
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
