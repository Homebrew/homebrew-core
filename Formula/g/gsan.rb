class Gsan < Formula
  include Language::Python::Virtualenv

  desc "Extract subdomains from SSL certificates in HTTPS sites"
  homepage "https://franccesco.github.io/getaltname/"
  url "https://files.pythonhosted.org/packages/73/0c/1fc5a29ae79fd74f0fd54d2c4d487b8cf7b21ede08efe99a6c39977816c6/gsan-5.0.0.tar.gz"
  sha256 "2418a6897b0eb1c6eb44c3521ccc5c69a811071f864b8001fd9699a4d2f4c9e3"
  license "MIT"
  revision 3
  head "https://github.com/franccesco/getaltname.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f4a523defbda42e8a69246d1d43ab8599b69604e09233b95ff5fcbe52d86e2c"
  end

  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/5c/5f/6583902b6f79b399c9c40674ac384fd9cd77805f9e6205075f828ef11fb2/pyasn1-0.6.3.tar.gz"
    sha256 "697a8ecd6d98891189184ca1fa05d1bb00e2f84b5977c481452050549c8a72cf"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/8e/11/a62e1d33b373da2b2c2cd9eb508147871c80f12b1cacde3c5d314922afdd/pyopenssl-26.0.0.tar.gz"
    sha256 "f293934e52936f2e3413b89c6ce36df66a0b34ae1ea3a053b8c5020ff2f513fc"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/f5/24/cb09efec5cc954f7f9b930bf8279447d24618bb6758d4f6adf2574c41780/typer-0.24.1.tar.gz"
    sha256 "e39b4732d65fbdcde189ae76cf7cd48aeae72919dea1fdfc16593be016256b45"
  end

  def install
    # Turn on shell completions option
    inreplace "src/gsan/main.py", "add_completion=False", "add_completion=True"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"gsan", shell_parameter_format: :typer)
  end

  test do
    assert_match(/google.com \[\d+\]/, shell_output("#{bin}/gsan google.com"))
  end
end
