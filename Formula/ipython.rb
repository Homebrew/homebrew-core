class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/7f/59/05e94e067afb61460f0d5229a1edb800e2f65b8436085fad9cd262d80d45/ipython-8.6.0.tar.gz"
  sha256 "7c959e3dedbf7ed81f9b9d8833df252c430610e2a4a6464ec13cd20975ce20a5"
  license "BSD-3-Clause"
  head "https://github.com/ipython/ipython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c310ffba0045b577add76134b6f5ba091656c5235e36d731279714353ade118b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bdc75485369281e3e3acb01d682363fabd324b0f64d342e44af4da1918f1499"
    sha256 cellar: :any_skip_relocation, monterey:       "9e9544d8656cc134aaaf8b3b544c3ec3462f9b666be36437aa743065a8935d59"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f9062c0fb956a813b45c2c1e185e2fe558a5af3d4ee1a8620ff00d439de803d"
    sha256 cellar: :any_skip_relocation, catalina:       "41606d618135e3f0d27650f5e28d64c1903aa1a775f593ef71bd0e1fac9bbaea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa8efd6c1023d2cef99cbf60746b90c668d1a5f7a1f77e1f3bafc21705b52ad0"
  end

  depends_on "pygments"
  depends_on "python@3.10"
  depends_on "six"

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/6a/cd/355842c0db33192ac0fc822e2dcae835669ef317fe56c795fb55fcddb26f/appnope-0.1.3.tar.gz"
    sha256 "02bd91c4de869fbb1e1c50aafc4098827a7a54ab2f39d9dcba6c9547ed920e24"
  end

  resource "asttokens" do
    url "https://files.pythonhosted.org/packages/ff/b9/40d8b5f23c59def4f4a67a807e899e00200db11f63b4ac9bde5838b709de/asttokens-2.1.0.tar.gz"
    sha256 "4aa76401a151c8cc572d906aad7aea2a841780834a19d780f4321c0fe1b54635"
  end

  resource "backcall" do
    url "https://files.pythonhosted.org/packages/a2/40/764a663805d84deee23043e1426a9175567db89c8b3287b5c2ad9f71aa93/backcall-0.2.0.tar.gz"
    sha256 "5cbdbf27be5e7cfadb448baf0aa95508f91f2bbc6c6437cd9cd06e2a4c215e1e"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "executing" do
    url "https://files.pythonhosted.org/packages/8f/ac/89ff37d8594b0eef176b7cec742ac868fef853b8e18df0309e3def9f480b/executing-1.2.0.tar.gz"
    sha256 "19da64c18d2d851112f09c287f8d3dbbdf725ab0e569077efb6cdcbd3497c107"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/c2/25/273288df952e07e3190446efbbb30b0e4871a0d63b4246475f3019d4f55e/jedi-0.18.1.tar.gz"
    sha256 "74137626a64a99c8eb6ae5832d99b3bdd7d29a3850fe2aa80a4126b2a7d949ab"
  end

  resource "matplotlib-inline" do
    url "https://files.pythonhosted.org/packages/d9/50/3af8c0362f26108e54d58c7f38784a3bdae6b9a450bab48ee8482d737f44/matplotlib-inline-0.1.6.tar.gz"
    sha256 "f887e5f10ba98e8d2b150ddcf4702c1e5f8b3a20005eb0f74bfdbd360ee6f304"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "pickleshare" do
    url "https://files.pythonhosted.org/packages/d8/b6/df3c1c9b616e9c0edbc4fbab6ddd09df9535849c64ba51fcb6531c32d4d8/pickleshare-0.7.5.tar.gz"
    sha256 "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/80/76/c94cf323ca362dd7baca8d8ddf3b5fe1576848bc0156522ad581c04f8446/prompt_toolkit-3.0.31.tar.gz"
    sha256 "9ada952c9d1787f52ff6d5f3484d0b4df8952787c087edf6a1f7c2cb1ea88148"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https://files.pythonhosted.org/packages/97/5a/0bc937c25d3ce4e0a74335222aee05455d6afa2888032185f8ab50cdf6fd/pure_eval-0.2.2.tar.gz"
    sha256 "2b45320af6dfaa1750f543d714b6d1c520a1688dec6fd24d339063ce0aaa9ac3"
  end

  resource "stack-data" do
    url "https://files.pythonhosted.org/packages/ff/d0/9231ffa0d7b5a93ffaa45b35f06502812829c6429907384534ce1ff79ac4/stack_data-0.6.0.tar.gz"
    sha256 "8e515439f818efaa251036af72d89e4026e2b03993f3453c000b200fb4f2d6aa"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/dd/a8/278742d17c9e95ccb0dcb86ae216df114d2166d88e72f42b60a7b58b600b/traitlets-5.5.0.tar.gz"
    sha256 "b122f9ff2f2f6c1709dab289a05555be011c87828e911c0cf4074b85cb780a79"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    python3 = "python3.10"
    venv = virtualenv_create(libexec, python3)
    res = resources.reject { |r| r.name == "appnope" && OS.linux? }
    venv.pip_install res
    venv.pip_install_and_link buildpath

    # Install man page
    man1.install libexec/"share/man/man1/ipython.1"
  end

  test do
    assert_equal "4", shell_output("#{bin}/ipython -c 'print(2+2)'").chomp
  end
end
