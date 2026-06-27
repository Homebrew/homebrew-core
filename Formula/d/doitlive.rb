class Doitlive < Formula
  include Language::Python::Virtualenv

  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/3f/50/d2715aa1b4dd5bfe1c91e5a332f5123180c2f2b1c8b0879389179b9f9c5e/doitlive-5.2.1.tar.gz"
  sha256 "7587a57c04fa74718e76cb4622f99ef6b762f1c861d0c1c2f843ab6bec53d063"
  license "MIT"
  head "https://github.com/sloria/doitlive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad9ad788d8f55216c2de2ce98bfc1de2f9f93b6f3705d3c20140c920cad71e61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a47920e296dce436daebe68c3ae423cdee4807ae552b82aa2c14690ddd609109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "493a7df97e0c82c5e933302a6dceb656880e0c904b432ed41d65a6381cf50a11"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a644b8fb2f5b57461fc7c26611898285734c646157f3334a5b4f8d0fed1c30c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "060e55176c3398eeaadec86f02006a74ccc51db74f81391843dfcfca9558fc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed0dcc035ead07431fa4f62a61cc880c3ca4dbb47132fdb6fb8b8f868a13f2cd"
  end

  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "click-completion" do
    url "https://files.pythonhosted.org/packages/93/18/74e2542defdda23b021b12b835b7abbd0fc55896aa8d77af280ad65aa406/click-completion-0.5.2.tar.gz"
    sha256 "5bf816b81367e638a190b6e91b50779007d14301b3f9f3145d68e3cade7bce86"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/30/ce/217289b77c590ea1e7c24242d9ddd6e249e52c795ff10fac2c50062c48cb/click_didyoumean-0.3.1.tar.gz"
    sha256 "4f82fdff0dbe64ef8ab2279bd6aa3f6a99c3b28c05aa09cbfc07c9d7fbb5a463"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"doitlive", "completion", shell_parameter_format: :none)
  end

  test do
    system bin/"doitlive", "themes", "--preview"
  end
end
