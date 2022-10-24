class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/25/a5/dda90aa8cb931458a357ae65ff4341d7694464f322b095a438489440dc7c/ipython-8.5.0.tar.gz"
  sha256 "097bdf5cd87576fd066179c9f7f208004f7a6864ee1b20f37d346c0bcb099f84"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ipython/ipython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c93abfbeab5871f295939a499f1217d61073f17dfdd94ec9bab28ebcd1ef7928"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1734a6faa3492f16ef42a68ab8b4cdbcab68a967abfe8d7f591be770cfe4a03"
    sha256 cellar: :any_skip_relocation, monterey:       "7a3b418182b17b2f98a61ca1a321f36726fd15253dfe1b861e3a2dfd809c3e4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a34a5225bb752fe75bcfc7d7ebcca8229e423b11fcbe55fc3d0d2635f75d56e"
    sha256 cellar: :any_skip_relocation, catalina:       "7fb5e7b1d731cee6a1434234b929917c5d6738c0aee2354c5c97b69e0ded82d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6830c3f27813551694e0dd91f59504a6f30499b27ebb03865de9d57d94108e95"
  end

  depends_on "pygments"
  depends_on "python@3.10"
  depends_on "six"

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/6a/cd/355842c0db33192ac0fc822e2dcae835669ef317fe56c795fb55fcddb26f/appnope-0.1.3.tar.gz"
    sha256 "02bd91c4de869fbb1e1c50aafc4098827a7a54ab2f39d9dcba6c9547ed920e24"
  end

  resource "asttokens" do
    url "https://files.pythonhosted.org/packages/4d/c8/987ee029c83ad1cddb03bb004e9c7a8de1be4cdbda21122a0b9f639fcc31/asttokens-2.0.8.tar.gz"
    sha256 "c61e16246ecfb2cde2958406b4c8ebc043c9e6d73aaa83c941673b35e5d3a76b"
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
    url "https://files.pythonhosted.org/packages/7e/f7/148b1a293f8187b0ea5327be6ec595731bf2b0dde8d6dae9c907a1ecd704/executing-1.0.0.tar.gz"
    sha256 "98daefa9d1916a4f0d944880d5aeaf079e05585689bebd9ff9b32e31dd5e1017"
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
    url "https://files.pythonhosted.org/packages/d6/3a/6baf4a5e7b48f00bc636bc878c6d93afd032dfeafc10b4a0a5a27232efb3/stack_data-0.5.0.tar.gz"
    sha256 "715c8855fbf5c43587b141e46cc9d9339cc0d1f8d6e0f98ed0d01c6cb974e29f"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/b2/ed/3c842dbe5a8f0f1ebf3f5b74fc1a46601ed2dfe0a2d256c8488d387b14dd/traitlets-5.3.0.tar.gz"
    sha256 "0bb9f1f9f017aa8ec187d8b1b2a7a6626a2a1d877116baba52a129bfa124f8e2"
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
