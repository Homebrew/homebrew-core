class Hapless < Formula
  include Language::Python::Virtualenv

  desc "Run and manage background processes"
  homepage "https://bmwant.link/hapless-easily-run-and-manage-background-processes/"
  url "https://files.pythonhosted.org/packages/2c/ab/a5c875f00927421371c9c36849030ba84dc171e7157575fd85126e893064/hapless-0.15.1.tar.gz"
  sha256 "b54707a5f77ac8e779bfd0c8c49344333e9d40a5c9479f0da1c303ffa237077d"
  license "MIT"
  head "https://github.com/bmwant/hapless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10bca31787230dbc7dea0b9c712227213933bfc8e787517336e05af2b20482ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbaab090f0b2b39cd85b5998db27b9b939f96913468ba3e996fe7d250babe00d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "811714c5adb45e7d208ac4131ba087a107cf255fad0d81ab4082ec3024c7938e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c24bf0290bdf13f87894126b8affc18cbbcf7557b24afbb8ed771381ec5729e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd5b41eadd8958beb78247a97440cc9f047868f068a1b24ed291264804a2e941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38580e0b77980e077abdfb6d5ae9b15423add9d65cb59630a62c41fb86e4495c"
  end

  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "django-environ" do
    url "https://files.pythonhosted.org/packages/d6/04/65d2521842c42f4716225f20d8443a50804920606aec018188bbee30a6b0/django_environ-0.12.0.tar.gz"
    sha256 "227dc891453dd5bde769c3449cf4a74b6f2ee8f7ab2361c93a07068f4179041a"
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
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
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
