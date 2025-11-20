class Hapless < Formula
  include Language::Python::Virtualenv

  desc "Run and manage background processes"
  homepage "https://bmwant.link/hapless-easily-run-and-manage-background-processes/"
  url "https://files.pythonhosted.org/packages/06/cd/6aac45f40878b332beb9397a67a0bd303c40739020fafa9118d11ec87941/hapless-0.14.0.tar.gz"
  sha256 "8eb7631d95336fd8ab33d3b1edc04bd48acc64ce6f2fd678bddfb0dca82cfe76"
  license "MIT"
  head "https://github.com/bmwant/hapless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f1b7e79dfde8dbe3455de9b60c62a99beb47ad4c4205ed6dc41eac53ad5e658"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64caa2c200a8de591971236bc8d4d3278659a168b54a1276f270e8bf668afca3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc139bf4e116e32d5361c3b4ee0d852a8652fb1045a8a198788024880cf69c58"
    sha256 cellar: :any_skip_relocation, sonoma:        "0002b73048141bbfee5af4902268a678ea4e8b43a5c15a4fa2f6f18378d54980"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dacaef22d5d890857200588faf20af1754969ccf1ba9857777cc922b83f3b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a67ed90db3f8ae881ae0d5419219deca72c4afba42e88cfb9c12def1d094698c"
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
    url "https://files.pythonhosted.org/packages/b6/43/50033d25ad96a7f3845f40999b4778f753c3901a11808a584fed7c00d9f5/humanize-4.14.0.tar.gz"
    sha256 "2fa092705ea640d605c435b1ca82b2866a1b601cdf96f076d70b79a855eba90d"
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

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hap --version")

    output = shell_output("#{bin}/hap status")
    assert_match "No haps are currently running", output
  end
end
